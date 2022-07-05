import 'package:flutter/material.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';

class CustomElevatedButton extends StatelessWidget {
  final double size;
  final Function() onPress;
  final String value;

  const CustomElevatedButton({
    Key? key,
    required this.onPress,
    required this.value,
    this.size = 45.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        primary: KColor.primary,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
      child: Container(
        height: size,
        alignment: Alignment.center,
        child: Text(
          value,
          style: context.getButtonText.copyWith(
            fontSize: size * 0.4,
            color: KColor.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
