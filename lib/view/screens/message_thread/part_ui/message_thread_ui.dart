import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/state_management/typing/typing_notification_bloc.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/screens/message_thread/part_ui/widgets/appbar_message_thread.dart';
import 'package:messenger_app/view/screens/message_thread/part_ui/widgets/comunication.dart';
import 'package:messenger_app/view/screens/message_thread/part_ui/widgets/input_messager.dart';
import 'package:messenger_app/view/screens/message_thread/state_management/message_thread_cubit.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';
import 'package:service/chat.dart';

class MessageThreadUI extends StatefulWidget {
  final User receiver;
  final User me;
  final TextEditingController textController;
  final Function() onSubmit;
  final TypingNotificationBloc typingBloc;
  final Function(String value) onStartTyping;
  final Function(bool focus) onFocusTextInput;

  const MessageThreadUI({
    Key? key,
    required this.receiver,
    required this.me,
    required this.textController,
    required this.onSubmit,
    required this.typingBloc,
    required this.onStartTyping,
    required this.onFocusTextInput,
  }) : super(key: key);

  @override
  _MessageThreadUIState createState() => _MessageThreadUIState();
}

class _MessageThreadUIState extends State<MessageThreadUI> {
  // controller
  final ScrollController _scrollController = ScrollController();

  bool get isLight => isLightTheme(context);
  List<LocalMessage> messages = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.disableKeyBoard,
      child: Scaffold(
        appBar: AppbarMessageThread(
            user: widget.receiver, typingBloc: widget.typingBloc),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Flexible(
              flex: 6,
              child: BlocBuilder<MessageThreadCubit, List<LocalMessage>>(
                  builder: _buildBlocComunicate),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: isLight ? KColor.white : KColor.superDarkGrey,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, -3),
                        blurRadius: 6.0,
                        color: isLight ? KColor.darkGrey : KColor.superDarkGrey,
                      )
                    ]),
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 12.0),
                    child: InputMessage(
                      controller: widget.textController,
                      onPress: widget.onSubmit,
                      onFocus: widget.onFocusTextInput,
                      onChange: widget.onStartTyping,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBlocComunicate(
    BuildContext context,
    List<LocalMessage> messages,
  ) {
    this.messages = messages;
    if (this.messages.isEmpty) return Container(color: KColor.none);
    WidgetsBinding.instance?.addPostFrameCallback(_scrollToEnd);
    return Comunication(
      messages: messages,
      receiver: widget.receiver,
      scrollControlller: _scrollController,
    );
  }

  void _scrollToEnd(Duration timeStamp) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(microseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
