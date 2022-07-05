import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';

bool isLightTheme(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.light;

class AppThemData {
  final BuildContext context;
  const AppThemData(this.context);

  static final AppBarTheme _appBarTheme = AppBarTheme(
    centerTitle: false,
    elevation: 0,
    backgroundColor: KColor.white,
  );

  static final TabBarTheme _tabBarTheme = TabBarTheme(
    indicatorSize: TabBarIndicatorSize.label,
    unselectedLabelColor: KColor.black,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
      color: KColor.primary,
    ),
  );

  static final dividerTheme =
      DividerThemeData().copyWith(thickness: 1.0, indent: 75.0);

  ThemeData lightTheme() => ThemeData.light().copyWith(
        primaryColorDark: KColor.darkPrimary,
        primaryColorLight: KColor.lightPrimary,
        primaryColor: KColor.primary,
        scaffoldBackgroundColor: KColor.white,
        appBarTheme: _appBarTheme,
        tabBarTheme: _tabBarTheme,
        dividerTheme: dividerTheme.copyWith(color: KColor.lightGrey),
        iconTheme: IconThemeData(color: KColor.darkGrey),
        textTheme: GoogleFonts.comfortaaTextTheme(context.getTextTheme)
            .apply(displayColor: KColor.black),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );

  ThemeData dartTheme() => ThemeData.dark().copyWith(
        primaryColorDark: KColor.darkPrimary,
        primaryColorLight: KColor.lightPrimary,
        primaryColor: KColor.primary,
        scaffoldBackgroundColor: KColor.black,
        appBarTheme: _appBarTheme.copyWith(backgroundColor: KColor.black),
        iconTheme: IconThemeData(color: KColor.black),
        dividerTheme: dividerTheme.copyWith(color: KColor.superDarkGrey),
        tabBarTheme: _tabBarTheme.copyWith(unselectedLabelColor: KColor.white),
        textTheme: GoogleFonts.comfortaaTextTheme(context.getTextTheme).apply(
          displayColor: KColor.white,
          decorationColor: KColor.white,
          bodyColor: KColor.white,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}
