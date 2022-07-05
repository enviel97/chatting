import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/data/datasource/datasource_contract.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/viewmodels/chat_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:service/chat.dart';

import 'chat_view_model_test.mocks.dart';

@GenerateMocks([IDatasource])
void main() {
  late ChatViewModel sut;
  late MockIDatasource mockIDatasource;

  setUp(() {
    mockIDatasource = MockIDatasource();
    sut = ChatViewModel(mockIDatasource);
  });

  final message = Message.fromJson({
    'from': '2708',
    'to': '1007',
    'contents': 'I miss you so much',
    'timestamp': DateTime.parse('2021-04-01'),
    'isEncrypted': false,
    'id': '1997',
  });

  test('initial messages return empty list', () async {
    when(mockIDatasource.findMessages(any)).thenAnswer((__) async => []);
    expect(await sut.getMessages('123'), isEmpty);
  });

  test('returns list of messages from local storage', () async {
    final chat = Chat('666');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.delivery);

    when(mockIDatasource.findMessages(chat.id))
        .thenAnswer((__) async => [localMessage]);

    final messages = await sut.getMessages('666');
    expect(messages, isNotEmpty);
    expect(messages.first.chatId, '666');
  });

  test('creates a new chat when sending first message', () async {
    when(mockIDatasource.findChat(any)).thenAnswer((__) async => null);
    await sut.sentMessage(message);
    verify(mockIDatasource.addChat(any)).called(1);
  });

  test('add new sent message to the chat', () async {
    final chat = Chat('666');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.delivery);
    when(mockIDatasource.findMessages(chat.id))
        .thenAnswer((__) async => [localMessage]);

    await sut.getMessages(chat.id);
    await sut.sentMessage(message);

    verifyNever(mockIDatasource.addChat(any));
    verify(mockIDatasource.addMessage(any)).called(1);
  });

  test('add new received message to the chat', () async {
    final chat = Chat('2708');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.delivery);

    when(mockIDatasource.findMessages(chat.id))
        .thenAnswer((__) async => [localMessage]);
    when(mockIDatasource.findChat(chat.id)).thenAnswer((__) async => chat);

    await sut.getMessages(chat.id);
    await sut.receivedMessage(message);

    verifyNever(mockIDatasource.addChat(any));
    verify(mockIDatasource.addMessage(any)).called(1);
  });

  test('create new chat when message received is not apart of this chat',
      () async {
    final chat = Chat('666');
    final localMessage = LocalMessage(chat.id, message, ReceiptStatus.delivery);

    when(mockIDatasource.findMessages(chat.id))
        .thenAnswer((__) async => [localMessage]);
    when(mockIDatasource.findChat(chat.id)).thenAnswer((__) async => null);

    await sut.getMessages(chat.id);
    await sut.receivedMessage(message);

    verify(mockIDatasource.addChat(any)).called(1);
    verify(mockIDatasource.addMessage(any)).called(1);
    expect(sut.otherMessages, 1);
  });
}
