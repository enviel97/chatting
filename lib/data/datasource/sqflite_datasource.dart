import 'package:messenger_app/data/datasource/datasource_contract.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:service/chat.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatasource implements IDatasource {
  final Database _db;
  const SqfliteDatasource(this._db);

  @override
  Future<void> addChat(Chat chat) async {
    await _db.transaction((txn) async {
      await txn.insert(
        TableName.chats,
        chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.rollback,
      );
    });
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _db.transaction((txn) async {
      await txn.insert(
        TableName.messages,
        message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batch = _db.batch();
    batch.delete(TableName.messages, where: 'chat_id = ?', whereArgs: [chatId]);
    batch.delete(TableName.chats, where: 'id = ?', whereArgs: [chatId]);
    await batch.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    _db.transaction((txt) async {
      print(txt);
    });
    return _db.transaction((txn) async {
      print(txn);
      final chatsWithLastestMessage =
          await txn.rawQuery('''SELECT messages.* FROM
      (SELECT
        chat_id, MAX(created_at) AS created_at
        FROM messages
        GROUP BY chat_id 
      ) AS lastest_messages
      INNER JOIN messages
      ON messages.chat_id = lastest_messages.chat_id
      AND messages.created_at = lastest_messages.created_at
      ''');

      if (chatsWithLastestMessage.isEmpty) return [];

      final chatsWithUnreadMessages =
          await txn.rawQuery('''SELECT chat_id, count(*) as unread 
      FROM messages
      WHERE receipt = ?
      GROUP BY chat_id
      ''', ['delivery']);

      return chatsWithLastestMessage.map<Chat>((row) {
        final int? unread = int.tryParse(chatsWithUnreadMessages
            .firstWhere(
              (ele) => row['chat_id'] == ele['chat_id'],
              orElse: () => {'unread': 0},
            )['unread']
            .toString());

        final chat = Chat.fromMap({"id": row['chat_id']});
        chat.unread = unread ?? 0;
        chat.mostRecent = LocalMessage.fromMap(row);
        return chat;
      }).toList();
    });
  }

  @override
  Future<Chat?> findChat(String chatId) async {
    return await _db.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        TableName.chats,
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
        'SELECT COUNT(*) FROM messages WHERE chat_id = ? AND receipt = ?',
        [chatId, 'deliverred'],
      ));

      final mostRecentMessage = await txn.query(
        TableName.messages,
        where: 'chat_id = ?',
        whereArgs: [chatId],
        orderBy: 'created_at DESC',
        limit: 1,
      );
      final chat = Chat.fromMap(listOfChatMaps.first);
      chat.unread = unread ?? 0;
      chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps = await _db.query(
      TableName.messages,
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );

    if (listOfMaps.isEmpty) return [];
    return listOfMaps
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _db.update(
      TableName.messages,
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status) {
    return _db.transaction((txn) async {
      await txn.update(
        TableName.messages,
        {'receipt': status.value},
        where: 'id = ?',
        whereArgs: [messageId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }
}
