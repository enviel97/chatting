import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/cache/local_cache.dart';
import 'package:messenger_app/root/config.dart';
import 'package:messenger_app/view/screens/home/state_management/home_state.dart';
import 'package:service/chat.dart';

class HomeCubit extends Cubit<HomeState> {
  IUserService _userService;

  ILocalCache _localCache;
  HomeCubit(this._userService, this._localCache) : super(HomeInitial());

  List<User> _formatUserList(List<User>? usersOnline) {
    if (usersOnline == null || usersOnline.isEmpty) return [];
    final List<User> usersWithNewURLImage = [];
    usersOnline.sort((a, b) => a.username.compareTo(b.username));
    usersWithNewURLImage.addAll(
      usersOnline.map(
        (User user) => user.copyWith(
          photoUrl: user.photoUrl.replaceAll(
              "http://localhost:3000", hosts['local-image']!['host-$device']),
        ),
      ),
    );
    return usersWithNewURLImage;
  }

  Future<void> activeUsers(User user) async {
    emit(HomeLoading());
    List<User> users = await _userService.online();
    users.removeWhere((element) => element.id == user.id);
    emit(HomeSuccess(_formatUserList(users)));
  }

  Future<void> refreshActiveUser(User user) async {
    emit(HomeLoading());
    final List<User> users = await _userService.online();
    users.removeWhere((element) => element.id == user.id);
    emit(HomeRefreshSuccess(_formatUserList(users)));
  }

  Future<User> connect(User user) async {
    final userJson = _localCache.fetch('USER');
    userJson['last_seen'] = DateTime.now();
    userJson['active'] = true;

    final user = User.fromJson(userJson);
    await _userService.connect(user);
    return user;
  }
}
