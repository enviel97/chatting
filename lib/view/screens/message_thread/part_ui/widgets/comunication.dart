import 'package:flutter/material.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/state_management/receipt/receipt_bloc.dart';
import 'package:messenger_app/view/screens/message_thread/part_ui/widgets/part_comunication/receiver_message.dart';
import 'package:messenger_app/view/screens/message_thread/part_ui/widgets/part_comunication/sender_message.dart';
import 'package:messenger_app/view/screens/message_thread/state_management/message_thread_cubit.dart';
import 'package:messenger_app/view/ultils/widget_ultils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service/chat.dart';

class Comunication extends StatefulWidget {
  final List<LocalMessage> messages;
  final ScrollController scrollControlller;
  final User receiver;
  // final Function(Typing event) onTyping;

  const Comunication({
    Key? key,
    required this.messages,
    required this.receiver,
    required this.scrollControlller,
  }) : super(key: key);

  @override
  _ComunicationState createState() => _ComunicationState();
}

class _ComunicationState extends State<Comunication> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        bottom: 20.0,
      ),
      itemCount: widget.messages.length,
      itemBuilder: (_, i) {
        if (widget.messages[i].message.from == widget.receiver.id) {
          _sendReceipt(widget.messages[i]);
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RecieverMessage(
              WidgetUltil.getImageWithUrl(widget.receiver.photoUrl),
              widget.messages[i],
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SenderMessager(widget.messages[i]),
          );
        }
      },
      controller: widget.scrollControlller,
      physics: AlwaysScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
    );
  }

  void _sendReceipt(LocalMessage message) async {
    if (message.receipt == ReceiptStatus.read) return;
    final Receipt receipt = Receipt(
      recipent: message.message.from,
      messageId: message.id,
      status: ReceiptStatus.read,
      timestamp: DateTime.now(),
    );
    context.read<ReceiptBloc>().add(ReceiptEvent.onReceiptSent(receipt));
    await context
        .read<MessageThreadCubit>()
        .viewModel
        .updateMessageReceipt(receipt);
  }
}
