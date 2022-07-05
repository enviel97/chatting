import 'package:messenger_app/models/local_message.dart';
import 'package:service/chat.dart';

class Chat {
  final String id;
  final List<LocalMessage> messages;

  User? from;
  int unread = 0;
  LocalMessage? mostRecent;

  Chat(
    this.id, {
    this.messages = const [],
    this.mostRecent,
  });

  Map<String, dynamic> toMap() => {'id': id};

  factory Chat.fromMap(Map<String, dynamic> json) => Chat(json['id']);
}
