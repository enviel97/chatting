import 'package:flutter/cupertino.dart';
import 'package:messenger_app/data/datasource/datasource_contract.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/models/local_message.dart';

abstract class BaseViewModel {
  final IDatasource _datasource;

  BaseViewModel(this._datasource);

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await isExistChat(message.chatId)) {
      await _createNewChat(message.chatId);
    }
    await _datasource.addMessage(message);
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = Chat(chatId);
    await _datasource.addChat(chat);
  }

  Future<bool> isExistChat(String chatId) async {
    return await _datasource.findChat(chatId) != null;
  }
}
