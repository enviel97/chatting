import 'package:service/chat.dart';

class LocalMessage {
  final String chatId;
  final Message message;
  final ReceiptStatus receipt;

  late String _id;

  LocalMessage(this.chatId, this.message, this.receipt) {
    _id = message.id;
  }

  String get id => _id;

  Map<String, dynamic> toMap() => {
        'chat_id': chatId,
        'id': message.id,
        'sender': message.from,
        'receiver': message.to,
        'contents': message.contents,
        'receipt': receipt.value,
        'received_at': message.timestamp.toString(),
        'is_encrypted': message.isEncrypted ? 1 : 0,
      };

  factory LocalMessage.fromMap(Map<String, dynamic> json) {
    final message = Message(
      from: json['sender'],
      to: json['receiver'],
      contents: json['contents'],
      timestamp: DateTime.parse(json['received_at']),
      isEncrypted: json['is_encrypted'] == 1,
    );
    final localMessage = LocalMessage(
      json['chat_id'],
      message,
      EnumParsing.fromString(json['receipt']),
    );
    localMessage._id = json['id'];
    return localMessage;
  }
}
