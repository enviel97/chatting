import 'package:flutter/material.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';

class App extends StatefulWidget {
  final Widget firstScreens;

  const App(this.firstScreens, {Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final bool isNewLogin = false;

  @override
  Widget build(BuildContext context) {
    final AppThemData apptheme = AppThemData(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: [const Locale('en', 'US'), const Locale('vi', 'VN')],
      theme: apptheme.lightTheme(),
      darkTheme: apptheme.dartTheme(),
      home: widget.firstScreens,
    );
  }
}
