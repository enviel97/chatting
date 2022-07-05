part of 'typing_notification_bloc.dart';

abstract class TypingNotificationEvent extends Equatable {
  const TypingNotificationEvent();

  factory TypingNotificationEvent.onSubscribed(User user,
          {List<String> usersWithChat = const []}) =>
      Subscribed(user, usersWithChat: usersWithChat);
  factory TypingNotificationEvent.onTypingEventSent(TypingEvent typing) =>
      TypingNotificationSent(typing);

  @override
  List<Object> get props => [];
}

class Subscribed extends TypingNotificationEvent {
  final User user;
  final List<String> usersWithChat;
  const Subscribed(this.user, {this.usersWithChat = const []});

  @override
  List<Object> get props => [user, usersWithChat];
}

class UnSubscribed extends TypingNotificationEvent {}

class TypingNotificationSent extends TypingNotificationEvent {
  final TypingEvent typing;
  const TypingNotificationSent(this.typing);

  @override
  List<Object> get props => [typing];
}

class _TypingNotificationReceived extends TypingNotificationEvent {
  final TypingEvent typing;
  const _TypingNotificationReceived(this.typing);

  @override
  List<Object> get props => [typing];
}
