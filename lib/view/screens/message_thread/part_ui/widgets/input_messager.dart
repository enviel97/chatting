import 'package:flutter/material.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';

class InputMessage extends StatefulWidget {
  final TextEditingController controller;
  final Function() onPress;
  final Function(bool focus) onFocus;
  final Function(String value) onChange;

  const InputMessage({
    Key? key,
    required this.controller,
    required this.onPress,
    required this.onFocus,
    required this.onChange,
  }) : super(key: key);

  @override
  _InputMessageState createState() => _InputMessageState();
}

class _InputMessageState extends State<InputMessage> {
  bool get isLight => isLightTheme(context);

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder _border = OutlineInputBorder(
      borderRadius: const BorderRadius.all(const Radius.circular(90.0)),
      borderSide: isLight
          ? BorderSide.none
          : BorderSide(color: KColor.lightGrey.withOpacity(.3)),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Focus(
          onFocusChange: widget.onFocus,
          child: TextFormField(
            controller: widget.controller,
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: context.getNormal,
            cursorColor: KColor.primary,
            onChanged: widget.onChange,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              hintText: "Aa",
              hintStyle: context.getHintText.copyWith(color: KColor.lightGrey),
              enabledBorder: _border,
              focusedBorder: _border,
              filled: true,
              fillColor: isLight
                  ? KColor.lightPrimary.withOpacity(0.1)
                  : KColor.lightBlack,
            ),
          ),
        )),
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Container(
            height: 45.0,
            width: 45.0,
            child: RawMaterialButton(
              fillColor: KColor.primary,
              shape: CircleBorder(),
              elevation: 5.0,
              onPressed: widget.onPress,
              child: Icon(
                Icons.send,
                color: KColor.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
