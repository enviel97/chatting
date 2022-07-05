import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/view/ultils/theme_data.dart' as app;

//static property

const TextStyle _defaultTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 14.0,
);

extension BuildContextX on BuildContext {
  // getScreens:
  double get widthScreens => MediaQuery.of(this).size.width;
  double get heightScreens => MediaQuery.of(this).size.height;

  // getTheme:
  TextTheme get getTextTheme => Theme.of(this).textTheme;

  // getTextStyleDefault
  TextStyle get getHeadline4 =>
      Theme.of(this).textTheme.headline4 ?? _defaultTextStyle;
  TextStyle get getButtonText =>
      Theme.of(this).textTheme.button ?? _defaultTextStyle;
  TextStyle get getHintText =>
      Theme.of(this).textTheme.caption ?? _defaultTextStyle;
  TextStyle get getSubtitle =>
      Theme.of(this).textTheme.subtitle2 ?? _defaultTextStyle;
  TextStyle get getOverline =>
      Theme.of(this).textTheme.overline ?? _defaultTextStyle;
  TextStyle get getNormal =>
      Theme.of(this).textTheme.bodyText2 ?? _defaultTextStyle;

  // Naviagetion:
  Future<Object?> goto(String screensId) =>
      Navigator.of(this).pushNamed(screensId)..onError(_onErrorNavigation);

  Future<Object?> replace(String screensId) => Navigator.of(this)
      .popAndPushNamed(screensId)
      .onError((error, stackTrace) => null);

  goBack<T>({T? result}) => Navigator.of(this).pop<T>(result);

  FutureOr<Object> _onErrorNavigation(dynamic error, dynamic stackTrace) {
    print('[NAVIGATION ERROR] : $error in $stackTrace');
    return 'Error';
  }

  // disable focus
  void disableKeyBoard() => FocusScope.of(this).requestFocus(FocusNode());
}
