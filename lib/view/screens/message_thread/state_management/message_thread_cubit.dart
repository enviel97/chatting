import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/viewmodels/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel viewModel;

  MessageThreadCubit(this.viewModel) : super([]);

  Future<void> messages(String chatId) async {
    final messages = await viewModel.getMessages(chatId);
    emit(messages);
  }
}
