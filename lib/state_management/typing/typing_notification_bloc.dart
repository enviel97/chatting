import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:service/chat.dart';
import 'package:equatable/equatable.dart';

part 'typing_notification_event.dart';
part 'typing_notification_state.dart';

class TypingNotificationBloc
    extends Bloc<TypingNotificationEvent, TypingNotificationState> {
  final ITypingNotification _typingNotification;
  StreamSubscription? _subscription;

  TypingNotificationBloc(this._typingNotification)
      : super(TypingNotificationState.initial());

  @override
  Future<void> close() {
    _subscription?.cancel();
    _typingNotification.dispose();
    return super.close();
  }

  @override
  Stream<TypingNotificationState> mapEventToState(
      TypingNotificationEvent typingEvent) async* {
    if (typingEvent is Subscribed) {
      if (typingEvent.usersWithChat.isEmpty) {
        add(UnSubscribed());
        return;
      }
      await _subscription?.cancel();
      _subscription = _typingNotification
          .subscribe(typingEvent.user, typingEvent.usersWithChat)
          .listen((typing) => add(_TypingNotificationReceived(typing)));
    }

    if (typingEvent is _TypingNotificationReceived) {
      yield TypingNotificationState.received(typingEvent.typing);
    }

    if (typingEvent is TypingNotificationSent) {
      await _typingNotification.send(event: typingEvent.typing);
      yield TypingNotificationState.sent();
    }

    if (typingEvent is UnSubscribed) {
      yield TypingNotificationState.initial();
    }
  }
}
