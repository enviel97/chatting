import 'package:messenger_app/data/datasource/sqflite_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:service/chat.dart';
import 'package:sqflite/sqflite.dart';
import 'sqflite_datasource_test.mocks.dart';

@GenerateMocks([Batch])
@GenerateMocks([Database])
void main() {
  late SqfliteDatasource sut;
  late MockDatabase database;
  late MockBatch batch;

  setUp(() async {
    database = MockDatabase();
    batch = MockBatch();
    sut = SqfliteDatasource(database);
  });

  final message = Message.fromJson({
    'from': '1007',
    'to': '2708',
    'contents': 'I miss you',
    'timestamp': DateTime.parse('2021-08-27'),
    'isEncrypted': false,
    'id': '4444'
  });

  test('should perform insert of chat to the database', () async {
    // arrange
    final chat = Chat('1997');
    when(database.insert(
      TableName.chats,
      chat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )).thenAnswer((_) async => 1);

    // act
    await sut.addChat(chat);

    // assert
    verify(database.insert(
      TableName.chats,
      chat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )).called(1);
  });

  test('should perform insert of message to the database', () async {
    //arrange
    final localMessage = LocalMessage('1234', message, ReceiptStatus.sent);

    when(database.insert(
      TableName.messages,
      localMessage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )).thenAnswer((_) async => 1);
    //act
    await sut.addMessage(localMessage);

    //assert
    verify(database.insert(
      TableName.messages,
      localMessage.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )).called(1);
  });

  test('should perform a database query and return message', () async {
    //arrange
    final messagesMap = [
      {
        'chat_id': '444',
        'id': '4444',
        'from': '111',
        'to': '222',
        'contents': 'hey',
        'isEncrypted': false,
        'receipt': 'sent',
        'timestamp': DateTime.parse("2021-04-01"),
      }
    ];
    when(database.query(
      TableName.messages,
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).thenAnswer((_) async => messagesMap);

    //act
    var messages = await sut.findMessages('111');

    //assert
    expect(messages.length, 1);
    expect(messages.first.chatId, '444');
    verify(database.query(
      TableName.messages,
      where: anyNamed('where'),
      whereArgs: anyNamed('whereArgs'),
    )).called(1);
  });

  test('should perform database update on messages', () async {
    //arrange
    final localMessage = LocalMessage('1234', message, ReceiptStatus.sent);
    when(database.update(TableName.messages, localMessage.toMap(),
            where: anyNamed('where'), whereArgs: anyNamed('whereArgs')))
        .thenAnswer((_) async => 1);

    //act
    await sut.updateMessage(localMessage);

    //assert
    verify(database.update(TableName.messages, localMessage.toMap(),
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            conflictAlgorithm: ConflictAlgorithm.replace))
        .called(1);
  });

  test('should perform database batch delete of chat', () async {
    //arrange
    final chatId = '111';
    when(database.batch()).thenReturn(batch);

    //act
    await sut.deleteChat(chatId);

    //assert
    verifyInOrder([
      database.batch(),
      batch.delete(TableName.messages,
          where: anyNamed('where'), whereArgs: [chatId]),
      batch.delete('chats', where: anyNamed('where'), whereArgs: [chatId]),
      batch.commit(noResult: true)
    ]);
  });
}
