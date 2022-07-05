import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

mixin SqlConfig {
  final String primaryKey = "PRIMARY KEY";
  final String notNull = "NOT NULL";
  final Map<String, String> type = const {
    "String": "TEXT",
    "DateTime": "TIMESTAMP",
    "int": "INTEGER",
  };

  String setDefault(String value) => "DEFAULT $value";

  String createTable(String name, {Map<String, dynamic>? params}) {
    String query = 'CREATE TABLE $name';
    if (params != null) {
      query += "(";
      params.forEach((key, value) {
        query += '\n$key       $value,';
      });
      query = query.substring(0, query.length - 1) + ')';
    }
    return query;
  }
}

class LocalDatabaseFactory with SqlConfig {
  Future<Database> createDatabase() async {
    final Directory databasePath = await getApplicationDocumentsDirectory();
    final String dbPath = join(databasePath.path, 'local_message.db');
    print(dbPath);
    final Database database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: populateDb,
      onConfigure: _onConfigure,
      onUpgrade: _onUpgrade,
      onOpen: _onOpen,
    );
    return database;
  }

  void populateDb(Database db, int version) async {
    await _createChatTable(db);
    await _createMessagesTable(db);
  }

  Future<void> _createChatTable(Database db) async {
    final String query = createTable("chats", params: {
      "id": "${type['String']} $primaryKey",
      "created_at":
          "${type['DateTime']} ${setDefault("CURRENT_TIMESTAMP")} $notNull",
    });
    await db
        .execute(query)
        .then((_) => print('create table chats ...'))
        .catchError((e) => print('error creating chats table:\n$e'));
  }

  Future<void> _createMessagesTable(Database db) async {
    final String query = createTable("messages", params: {
      "chat_id": "${type['String']} $notNull",
      "id": "${type['String']} $primaryKey",
      "sender": "${type['String']} $notNull",
      "receiver": "${type['String']} $notNull",
      "contents": "${type['String']} $notNull",
      "receipt": "${type['String']} $notNull",
      "received_at": "${type['String']} $notNull",
      "is_encrypted": "${type['int']} ${setDefault("1")} $notNull",
      "created_at":
          "${type['DateTime']} ${setDefault("CURRENT_TIMESTAMP")} $notNull",
    });
    await db
        .execute(query)
        .then((_) => print('create table messages ...'))
        .catchError((e) => print('error creating chats table:\n$e'));
  }

  FutureOr<void> _onConfigure(Database db) {
    print('db_factory configure      $db');
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int newVersion) {
    print('db_factory upgrade $oldVersion $newVersion');
  }

  FutureOr<void> _onOpen(Database db) {
    print('db_factory open $db ');
  }
}
