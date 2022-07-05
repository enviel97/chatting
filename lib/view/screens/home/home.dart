import 'package:flutter/material.dart';
import 'package:messenger_app/root/routes/home_route.dart';
import 'package:messenger_app/state_management/message/message_bloc.dart';
import 'package:messenger_app/view/screens/home/part_ui/home_ui.dart';
import 'package:messenger_app/view/screens/home/state_management/home_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/view/screens/home/tab_element/chats/state_management/chats_cubit.dart';
import 'package:service/chat.dart';

class Home extends StatefulWidget {
  final User me;
  final IHomeRouter router;

  const Home({Key? key, required this.me, required this.router})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.me;
    _initalSetup();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return HomeUI(user: _user, router: widget.router);
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _initalSetup() async {
    final user = (!_user.active)
        ? await context.read<HomeCubit>().connect(_user)
        : _user;

    context.read<ChatsCubit>().chats();
    context.read<HomeCubit>().activeUsers(user);
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(_user));
  }
}
