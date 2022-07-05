import 'package:flutter/material.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';
import 'package:messenger_app/view/ultils/widget_ultils.dart';
import 'package:service/chat.dart';

class SenderMessager extends StatelessWidget {
  final LocalMessage _message;
  const SenderMessager(this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = isLightTheme(context);
    return FractionallySizedBox(
      alignment: Alignment.centerRight,
      widthFactor: 0.75,
      child: Stack(
        textDirection: TextDirection.rtl,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: KColor.primary,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  position: DecorationPosition.background,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      _message.message.contents,
                      style: context.getNormal.copyWith(
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                  child: Text(
                    WidgetUltil.dateCalculator(_message.message.timestamp),
                    style: context.getOverline,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _message.receipt == ReceiptStatus.read
                      ? KColor.green
                      : KColor.lightBlack,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.check_circle_outline_rounded,
                  color: _message.receipt == ReceiptStatus.read
                      ? KColor.white
                      : KColor.darkGrey,
                  size: 20.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
