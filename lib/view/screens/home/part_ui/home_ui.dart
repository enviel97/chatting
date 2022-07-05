import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/root/routes/home_route.dart';
import 'package:messenger_app/view/screens/home/tab_element/active/active.dart';
import 'package:messenger_app/view/screens/home/tab_element/chats/chats.dart';
import 'package:messenger_app/view/screens/home/widgets/tab_manager.dart';
import 'package:messenger_app/view/screens/widgets/header_status.dart';
import 'package:service/chat.dart';

class HomeUI extends StatefulWidget {
  final User user;
  final IHomeRouter router;

  const HomeUI({
    Key? key,
    required this.user,
    required this.router,
  }) : super(key: key);

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: HeaderStatus(
            active: widget.user.active,
            lastseen: widget.user.lastseen,
            photoUrl: widget.user.photoUrl,
            username: widget.user.username,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabManager(),
          ),
        ),
        body: SafeArea(
            child: TabBarView(
          children: [
            Chats(user: widget.user, router: widget.router),
            Active(user: widget.user, router: widget.router),
          ],
        )),
      ),
    );
  }
}
