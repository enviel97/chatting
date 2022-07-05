import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/viewmodels/chats_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel viewModel;
  ChatsCubit(this.viewModel) : super([]);

  Future<void> chats() async {
    final chats = await viewModel.getChats();
    emit(chats);
  }
}
