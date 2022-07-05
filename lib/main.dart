import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messenger_app/root/composition_root.dart';
import 'package:messenger_app/view/app.dart';
import 'package:messenger_app/view/ultils/widget_ultils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    sqfliteFfiInit();
  }
  await CompositionRoot.configure();
  final firstScreens = CompositionRoot.start();
  WidgetUltil.transparent_status_bar;
  runApp(App(firstScreens));
}
