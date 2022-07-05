import 'package:flutter/material.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';
import 'package:messenger_app/view/widgets/dot.dart';
import 'package:messenger_app/view/widgets/image_network.dart';

class ProfileImage extends StatelessWidget {
  final double size;
  final bool isOnline;

  final String imageUrl;

  const ProfileImage({
    Key? key,
    this.size = 126.0,
    required this.imageUrl,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = isLightTheme(context) ? KColor.white : KColor.black;
    return CircleAvatar(
      backgroundColor: KColor.none,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(size / 2),
            child: ImageNetWork(imageUrl),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: isOnline
                ? Dot(
                    color: KColor.green,
                    borderColor: color,
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
