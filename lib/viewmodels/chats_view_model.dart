import 'package:messenger_app/data/datasource/datasource_contract.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/viewmodels/base_view_model.dart';
import 'package:service/chat.dart';

class ChatsViewModel extends BaseViewModel {
  final IDatasource _datasource;
  final IUserService _userService;

  ChatsViewModel(this._datasource, this._userService) : super(_datasource);

  Future<List<Chat>> getChats() async {
    final chats = await _datasource.findAllChats();

    await Future.forEach(chats, (Chat chat) async {
      final user = await _userService.fetch(chat.id);
      chat.from = user;
    });
    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage = LocalMessage(
      message.from,
      message,
      ReceiptStatus.delivery,
    );
    await addMessage(localMessage);
  }
}
