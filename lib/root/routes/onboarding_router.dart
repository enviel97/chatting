import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:service/chat.dart';

abstract class IOnboardingRouter {
  const IOnboardingRouter();
  void onSesstionSuccess(BuildContext context, User me);
}

class OnboardingRouter extends IOnboardingRouter {
  final Widget Function(User me) onSesstionConnected;

  const OnboardingRouter(this.onSesstionConnected);

  @override
  void onSesstionSuccess(BuildContext context, User me) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => onSesstionConnected(me)),
      (Route<dynamic> route) => false,
    );
  }
}
