import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/state_management/typing/typing_notification_bloc.dart';
import 'package:messenger_app/view/screens/widgets/header_status.dart';
import 'package:service/chat.dart';

class AppbarMessageThread extends StatelessWidget with PreferredSizeWidget {
  final User user;
  final TypingNotificationBloc typingBloc;

  const AppbarMessageThread({
    Key? key,
    required this.user,
    required this.typingBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(true),
            icon: Icon(Icons.arrow_back_ios_rounded),
          ),
          Expanded(
            child: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
              bloc: typingBloc,
              builder: (BuildContext context, state) {
                bool? typing;

                if (state is TypingNotificationReceivedSuccess &&
                    state.event.event == Typing.start &&
                    state.event.from == user.id) {
                  typing = true;
                }
                return HeaderStatus(
                  username: user.username,
                  photoUrl: user.photoUrl,
                  active: user.active,
                  lastseen: user.lastseen,
                  typing: typing,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}
