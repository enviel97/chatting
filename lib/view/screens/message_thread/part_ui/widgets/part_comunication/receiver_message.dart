import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messenger_app/models/local_message.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';
import 'package:messenger_app/view/ultils/widget_ultils.dart';
import 'package:messenger_app/view/widgets/image_network.dart';

class RecieverMessage extends StatelessWidget {
  final String _url;
  final LocalMessage _message;
  const RecieverMessage(this._url, this._message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLight = isLightTheme(context);
    return FractionallySizedBox(
      alignment: Alignment.topLeft,
      widthFactor: 0.75,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: isLight ? KColor.lightGrey : KColor.lightBlack,
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
                  padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                  child: Text(
                    WidgetUltil.dateCalculator(_message.message.timestamp),
                    style: context.getOverline,
                  ),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 18.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: ImageNetWork(_url, size: 126.0),
            ),
          )
        ],
      ),
    );
  }
}
