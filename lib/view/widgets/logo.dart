import 'package:flutter/material.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';
import 'package:messenger_app/view/ultils/widget_ultils.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String pathLogo = WidgetUltil.getLogoAsset(isLightTheme(context));
    const double size = 50.0;
    return Container(
      child: Image.asset(
        pathLogo,
        fit: BoxFit.fill,
        height: size,
        width: size,
      ),
    );
  }
}
