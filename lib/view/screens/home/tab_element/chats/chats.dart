import 'package:flutter/material.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/root/routes/home_route.dart';
import 'package:messenger_app/state_management/message/message_bloc.dart';
import 'package:messenger_app/state_management/typing/typing_notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/view/screens/home/tab_element/chats/state_management/chats_cubit.dart';
import 'package:messenger_app/view/screens/home/tab_element/chats/widgets/chat_item.dart';
import 'package:service/chat.dart';

class Chats extends StatefulWidget {
  final User user;

  final IHomeRouter router;
  const Chats({Key? key, required this.user, required this.router})
      : super(key: key);

  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  List<Chat> _chats = const [];
  final List typingEvents = const [];

  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceived();
    context.read<ChatsCubit>().chats();
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ChatsCubit, List<Chat>>(builder: _buildBlocBuilder);

  void _updateChatsOnMessageReceived() {
    final ChatsCubit chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatsCubit.viewModel.receivedMessage(state.message);
        chatsCubit.chats();
      }
    });
  }

  Widget _buildListChats() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 30.0, right: 16.0, bottom: 10.0),
      itemBuilder: (_, index) => GestureDetector(
        onTap: () async {
          await widget.router.onShowMessageThread(
            context,
            _chats[index].from!,
            widget.user,
            chatId: _chats[index].id,
          );
          await context.read<ChatsCubit>().chats();
        },
        child: ChatItem(
          chat: _chats[index],
          typingEvents: typingEvents,
        ),
      ),
      separatorBuilder: (_, __) => Divider(),
      itemCount: _chats.length,
    );
  }

  Widget _buildBlocBuilder(BuildContext context, List<Chat> chats) {
    this._chats = chats;
    if (this._chats.isEmpty) return Container();
    context.read<TypingNotificationBloc>().add(
          TypingNotificationEvent.onSubscribed(
            widget.user,
            usersWithChat: chats.map((e) => e.from!.id).toList(),
          ),
        );
    return _buildListChats();
  }
}
