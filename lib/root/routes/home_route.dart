import 'package:flutter/material.dart';
import 'package:service/chat.dart';

abstract class IHomeRouter {
  const IHomeRouter();
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {required String chatId});
}

class HomeRouter extends IHomeRouter {
  final Widget Function(User receiver, User me, {required String chatId})
      showMessageThread;

  const HomeRouter({required this.showMessageThread});

  @override
  Future<void> onShowMessageThread(BuildContext context, User receiver, User me,
      {required String chatId}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => showMessageThread(receiver, me, chatId: chatId),
      ),
    );
  }
}
