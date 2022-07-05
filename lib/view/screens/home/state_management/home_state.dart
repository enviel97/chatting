import 'package:equatable/equatable.dart';
import 'package:service/chat.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeRefreshSuccess extends HomeState {
  final List<User> onlineUsers;
  const HomeRefreshSuccess(this.onlineUsers);

  @override
  List<Object?> get props => [onlineUsers];
}

class HomeSuccess extends HomeState {
  final List<User> onlineUsers;
  const HomeSuccess(this.onlineUsers);
  @override
  List<Object?> get props => [onlineUsers];
}
