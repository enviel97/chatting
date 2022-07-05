import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/root/config.dart';

class WidgetUltil {
  // ignore: non_constant_identifier_names
  static void get transparent_status_bar =>
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ));

  static String getLogoAsset(bool isLightTheme) {
    String type = isLightTheme ? 'light' : 'dark';
    return 'assets/images/logo/logo_$type.png';
  }

  static String getImageWithUrl(String? url) {
    if (url == null || url.isEmpty) {
      return "";
    }
    final String imageHost = hosts['local-image']!['host-$device'];
    String newUrl = url;
    if (url.contains("http://localhost:3000")) {
      newUrl = url.replaceAll("http://localhost:3000", imageHost);
    }
    return newUrl;
  }

  static String dateCalculator(DateTime? timestamp) {
    if (timestamp == null) return throw NullThrownError();
    final Duration dmy = DateTime.now().difference(timestamp).abs();
    if (dmy.inDays > 0) return DateFormat('dd/MM/y hh:mm').format(timestamp);
    if (dmy.inHours > 0) return DateFormat('hh:mm a').format(timestamp);
    return '${DateFormat('m').format(timestamp)} min';
  }

  static String getHost(String type) => hosts['local-$type']!['host-$device'];

  static int getPort(String type) => hosts['local-$type']!['port'];
}
