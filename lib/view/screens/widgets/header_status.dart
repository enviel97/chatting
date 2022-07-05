import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/ultils/widget_ultils.dart';
import 'package:messenger_app/view/widgets/profile_image.dart';

class HeaderStatus extends StatelessWidget {
  final String username;
  final String photoUrl;
  final bool active;
  final DateTime lastseen;
  final bool? typing;
  const HeaderStatus({
    Key? key,
    required this.username,
    required this.photoUrl,
    required this.active,
    required this.lastseen,
    this.typing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      child: Row(
        children: [
          ProfileImage(
              imageUrl: WidgetUltil.getImageWithUrl(photoUrl),
              isOnline: active),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  username.trim(),
                  style: context.getHintText
                      .copyWith(fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                _buildSubname(context),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubname(BuildContext context) {
    if (typing == null) {
      final dateFormat = DateFormat.yMMMMd().add_jm().format(lastseen);
      final String status = active ? 'online' : 'Lastseen: $dateFormat';
      return Text(status, style: context.getHintText);
    }
    return Text('typing...',
        style: context.getHintText.copyWith(fontStyle: FontStyle.italic));
  }
}
