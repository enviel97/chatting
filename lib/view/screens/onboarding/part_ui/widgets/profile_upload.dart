import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/screens/onboarding/states_management/profile_image/profile_image_cubit.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';

class ProfileUpload extends StatelessWidget {
  const ProfileUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isLight = isLightTheme(context);
    final Color materialColor = isLight ? KColor.grey : KColor.lightGrey;
    const double size = 126.0;
    return Container(
      height: size,
      width: size,
      child: Material(
        color: materialColor,
        borderRadius: BorderRadius.circular(size),
        child: InkWell(
          borderRadius: BorderRadius.circular(size),
          onTap: () => _onTap(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundColor: KColor.none,
                child: BlocBuilder<ProfileImageCubit, File?>(
                  builder: (BuildContext context, File? state) {
                    return state == null
                        ? _buildEmptyAvatar(size)
                        : _buildUserAvatar(size, state);
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.add_circle_rounded,
                    size: size * 0.32,
                    color: KColor.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Icon _buildEmptyAvatar(double size) {
    return Icon(
      Icons.person_rounded,
      size: size * 0.6,
      color: KColor.darkGrey,
    );
  }

  ClipRRect _buildUserAvatar(double size, File state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: Image.file(
        state,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }

  void _onTap(BuildContext context) async {
    await context.read<ProfileImageCubit>().getImage();
  }
}
