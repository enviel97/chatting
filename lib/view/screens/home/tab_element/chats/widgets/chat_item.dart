import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/models/chat.dart';
import 'package:messenger_app/state_management/typing/typing_notification_bloc.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/ultils/widget_ultils.dart';
import 'package:messenger_app/view/widgets/dot.dart';
import 'package:messenger_app/view/widgets/profile_image.dart';
import 'package:service/chat.dart';

class ChatItem extends StatelessWidget {
  final Chat chat;
  final List typingEvents;
  const ChatItem({Key? key, required this.chat, required this.typingEvents})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16.0),
      leading: ProfileImage(
        imageUrl: WidgetUltil.getImageWithUrl(chat.from?.photoUrl),
        isOnline: chat.from?.active ?? false,
      ),
      title: Text(
        chat.from?.username ?? "{{undefine}}",
        style: context.getSubtitle.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
        builder: (context, state) => _buildBlocBuilder(context, state, chat),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            WidgetUltil.dateCalculator(chat.mostRecent?.message.timestamp),
            style: context.getOverline,
          ),
          const SizedBox(height: 8.0),
          chat.unread > 0
              ? Dot(
                  color: KColor.primary,
                  borderColor: KColor.white,
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildBlocBuilder(
      BuildContext context, TypingNotificationState state, Chat chat) {
    if (state is TypingNotificationReceivedSuccess &&
        state.event.from == chat.from!.id) {
      if (state.event.event == Typing.start) {
        this.typingEvents.add(state.event.from);
      }

      if (state.event.event == Typing.stop) {
        this.typingEvents.remove(state.event.from);
      }
    }
    if (this.typingEvents.contains(chat.from!.id))
      return Text('typing...',
          style: context.getHintText.copyWith(fontStyle: FontStyle.italic));

    return Text(
      chat.mostRecent?.message.contents ?? "",
      maxLines: 2,
      softWrap: true,
      overflow: TextOverflow.fade,
      style: context.getOverline.copyWith(
          fontWeight: chat.unread > 0 ? FontWeight.bold : FontWeight.normal),
    );
  }
}
