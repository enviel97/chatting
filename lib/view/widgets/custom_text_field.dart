import 'package:flutter/material.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final double height;
  final Function(String string) onChanged;
  final TextInputAction inputAction;

  const CustomTextField({
    Key? key,
    required this.hint,
    required this.onChanged,
    required this.inputAction,
    this.height = 54.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = isLightTheme(context);
    final Color backgroundColor = KColor.lightGrey;
    final Color hintColor = isLight ? KColor.black : KColor.primary;
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(45.0),
          border: Border.all(
            color: backgroundColor,
            width: 1.5,
          )),
      height: height,
      child: TextField(
        keyboardType: TextInputType.text,
        onChanged: onChanged,
        textInputAction: inputAction,
        cursorColor: KColor.primary,
        style: TextStyle(color: KColor.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 8.0,
          ),
          hintText: hint,
          hintStyle: context.getHintText.copyWith(color: hintColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
