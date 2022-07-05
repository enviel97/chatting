import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_app/data/datasource/datasource_contract.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/viewmodels/chats_view_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:service/chat.dart';
import 'chats_view_model_test.mocks.dart';

class MockIUserService extends Mock with IUserService {}

@GenerateMocks([IDatasource, Chat, LocalMessage])
Future<void> main() async {
  late ChatsViewModel sut;
  late MockIDatasource mockDatasource;
  late MockIUserService userService;

  setUp(() {
    mockDatasource = MockIDatasource();
    userService = MockIUserService();
    sut = ChatsViewModel(mockDatasource, userService);
  });

  final message = Message.fromJson({
    'from': '1007',
    'to': '2708',
    'contents': 'I miss you',
    'timestamp': DateTime.parse('2021-04-01'),
    'id': '1997',
    'isEncrypted': false,
  });

  test('initial chats return empty', () async {
    when(mockDatasource.findAllChats()).thenAnswer((_) async => []);
    expect(await sut.getChats(), isEmpty);
  });

  test('return list of chats', () async {
    final chat = Chat('2708');
    when(mockDatasource.findAllChats()).thenAnswer((_) async => [chat]);
    final chats = await sut.getChats();
    expect(chats, isNotEmpty);
  });

  test('creates a new chat when receiving message for the first time',
      () async {
    when(mockDatasource.findChat(any)).thenAnswer((_) async => null);
    await sut.receivedMessage(message);
    verify(mockDatasource.addChat(any)).called(1);
  });

  test('add new message to exiting chat', () async {
    final chat = Chat('2708');
    when(mockDatasource.findChat(any)).thenAnswer((_) async => chat);
    await sut.receivedMessage(message);
    verifyNever(mockDatasource.addChat(any));
    verify(mockDatasource.addMessage(any)).called(1);
  });
}
