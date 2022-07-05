import 'package:flutter/material.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';
import 'package:messenger_app/view/widgets/logo.dart';

class LogoRow extends StatelessWidget {
  const LogoRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = isLightTheme(context);
    final Color textColor = isLight ? KColor.black : KColor.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'C',
          style: context.getHeadline4.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Logo(),
        Text(
          'NNECT',
          style: context.getHeadline4.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
