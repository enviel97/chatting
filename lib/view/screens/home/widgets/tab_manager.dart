import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/view/screens/home/state_management/home_cubit.dart';
import 'package:messenger_app/view/screens/home/state_management/home_state.dart';

class TabManager extends StatefulWidget {
  final Function(int position)? onTapTab;

  TabManager({Key? key, this.onTapTab}) : super(key: key);

  @override
  _TabManagerState createState() => _TabManagerState();
}

class _TabManagerState extends State<TabManager> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
        indicatorPadding: const EdgeInsets.all(5.0),
        onTap: widget.onTapTab,
        tabs: [
          Tab(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text('Messages'),
              ),
            ),
          ),
          // _tabDecorationDefault(widget.titles[0]),
          Tab(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Align(
                alignment: Alignment.center,
                child: BlocBuilder<HomeCubit, HomeState>(builder: (_, state) {
                  int onlines = 0;
                  if (state is HomeSuccess) {
                    onlines = state.onlineUsers.length;
                  }
                  if (state is HomeRefreshSuccess) {
                    onlines = state.onlineUsers.length;
                  }
                  return Text('Active ($onlines)');
                }),
              ),
            ),
          ),
        ]);
  }
}
