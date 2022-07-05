import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/root/routes/home_route.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/screens/home/state_management/home_cubit.dart';
import 'package:messenger_app/view/screens/home/state_management/home_state.dart';
import 'package:messenger_app/view/widgets/profile_image.dart';
import 'package:service/chat.dart';

class Active extends StatefulWidget {
  final User user;
  final IHomeRouter router;
  const Active({
    Key? key,
    required this.user,
    required this.router,
  }) : super(key: key);

  @override
  _ActiveState createState() => _ActiveState();
}

class _ActiveState extends State<Active> {
  List<User> usersOnline = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (_, state) {
        if (state is HomeSuccess) {
          usersOnline = state.onlineUsers;
        }
        if (state is HomeRefreshSuccess) {
          usersOnline = state.onlineUsers;
        }
        if (usersOnline.isEmpty) return _buildError();
        return _buildList(usersOnline);
      },
    );
  }

  Widget _buildItemBuilder(User user) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16.0, top: 10.0),
      leading: ProfileImage(
        imageUrl: user.photoUrl,
        isOnline: user.active,
      ),
      title: Text(
        user.username,
        style: context.getSubtitle.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildList(List<User> users) {
    return RefreshIndicator(
      color: KColor.primary,
      onRefresh: _pullToRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        itemBuilder: (_, i) => GestureDetector(
          onTap: () async => await widget.router.onShowMessageThread(
              context, users[i], widget.user,
              chatId: usersOnline[i].id),
          child: _buildItemBuilder(users[i]),
        ),
        itemCount: users.length,
      ),
    );
  }

  Widget _buildError() {
    return Container();
  }

  Future<void> _pullToRefresh() async {
    await context.read<HomeCubit>().refreshActiveUser(widget.user);
  }
}
