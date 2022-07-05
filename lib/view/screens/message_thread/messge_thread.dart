import 'dart:async';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/state_management/message/message_bloc.dart';
import 'package:messenger_app/state_management/receipt/receipt_bloc.dart';
import 'package:messenger_app/state_management/typing/typing_notification_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/view/screens/home/tab_element/chats/state_management/chats_cubit.dart';
import 'package:messenger_app/view/screens/message_thread/part_ui/message_thread_ui.dart';
import 'package:messenger_app/view/screens/message_thread/state_management/message_thread_cubit.dart';
import 'package:service/chat.dart';

class MessageThread extends StatefulWidget {
  final User receiver;
  final User me;
  final String chatId;
  final MessageBloc messageBloc;
  final ChatsCubit chatsCubit;
  final TypingNotificationBloc typingNotificationBloc;

  MessageThread({
    Key? key,
    required this.receiver,
    required this.me,
    required this.chatId,
    required this.chatsCubit,
    required this.typingNotificationBloc,
    required this.messageBloc,
  }) : super(key: key);

  @override
  _MessageThreadState createState() => _MessageThreadState();
}

class _MessageThreadState extends State<MessageThread> {
  // state props
  late User receiver;
  late StreamSubscription _subscription;

  String chatId = '';
  List<LocalMessage> messages = [];

  final TextEditingController _textController = TextEditingController();

  // state props
  Timer? _startTypingTimer;
  Timer? _stopTypingTimer;

  @override
  void dispose() {
    _subscription.cancel();
    _textController.dispose();
    _stopTypingTimer?.cancel();
    _startTypingTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _propsToState();

    _updateOnMessageReceived();
    _updateOnReceiptReceived();

    _propsToEvent();
  }

  @override
  Widget build(BuildContext context) {
    return MessageThreadUI(
      receiver: receiver,
      me: widget.me,
      onSubmit: _sendMessage,
      textController: _textController,
      typingBloc: widget.typingNotificationBloc,
      onFocusTextInput: (bool focus) {
        if (_startTypingTimer == null || (_startTypingTimer != null && focus))
          return;
        _stopTypingTimer?.cancel();
        _dispatchTyping(Typing.stop);
      },
      onStartTyping: _sentTypingNotificaion,
    );
  }

  void _propsToState() {
    chatId = widget.chatId;
    receiver = widget.receiver;
  }

  void _propsToEvent() {
    context.read<ReceiptBloc>().add(ReceiptEvent.onSubscribed(widget.me));
    widget.typingNotificationBloc.add(TypingNotificationEvent.onSubscribed(
      widget.me,
      usersWithChat: [receiver.id],
    ));
  }

  void _updateOnMessageReceived() {
    final thisCubit = context.read<MessageThreadCubit>();
    if (chatId.isNotEmpty) thisCubit.messages(chatId);

    _subscription = widget.messageBloc.stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await thisCubit.viewModel.receivedMessage(state.message);
        final receipt = Receipt(
            recipent: state.message.from,
            messageId: state.message.id,
            status: ReceiptStatus.read,
            timestamp: DateTime.now());
        context.read<ReceiptBloc>().add(ReceiptEvent.onReceiptSent(receipt));
      }
      if (state is MessageSentSuccess) {
        await thisCubit.viewModel.sentMessage(state.message);
      }
      if (chatId.isEmpty) chatId = thisCubit.viewModel.chatId;
      thisCubit.messages(chatId);
    });
  }

  void _updateOnReceiptReceived() {
    final thisCubit = context.read<MessageThreadCubit>();
    context.read<ReceiptBloc>().stream.listen((state) async {
      if (state is ReceiptReceivedSuccess) {
        await thisCubit.viewModel.updateMessageReceipt(state.receipt);
        thisCubit.messages(chatId);
        widget.chatsCubit.chats();
      }
    });
  }

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    final message = Message(
        to: widget.receiver.id,
        from: widget.me.id,
        contents: _textController.text,
        timestamp: DateTime.now());
    final sendMessagerEvent = MessageEvent.onMessageSent(message);
    widget.messageBloc.add(sendMessagerEvent);
    _textController.clear();
    _stopTypingTimer?.cancel();
    _startTypingTimer?.cancel();
    _dispatchTyping(Typing.stop);
  }

  void _dispatchTyping(Typing event) {
    final TypingEvent typing = TypingEvent(
      from: widget.me.id,
      to: widget.receiver.id,
      event: event,
    );
    widget.typingNotificationBloc
        .add(TypingNotificationEvent.onTypingEventSent(typing));
  }

  void _sentTypingNotificaion(String text) {
    if (text.trim().isEmpty || messages.isEmpty) return;
    if (_startTypingTimer?.isActive ?? false) return;
    if (_startTypingTimer?.isActive ?? false) _stopTypingTimer?.cancel();
    _dispatchTyping(Typing.start);
    _startTypingTimer = Timer(const Duration(seconds: 5), () {});
    _stopTypingTimer =
        Timer(const Duration(seconds: 6), () => _dispatchTyping(Typing.stop));
  }
}
