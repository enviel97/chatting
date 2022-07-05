import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/root/routes/onboarding_router.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/screens/onboarding/part_ui/onboarding_ui.dart';
import 'package:messenger_app/view/screens/onboarding/states_management/onboarding/onboarding_cubit.dart';
import 'package:messenger_app/view/screens/onboarding/states_management/profile_image/profile_image_cubit.dart';
import 'package:messenger_app/view/ultils/theme_data.dart';

class Onboarding extends StatefulWidget {
  final IOnboardingRouter router;

  const Onboarding({Key? key, required this.router}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  String _username = '';
  bool get isLight => isLightTheme(context);

  @override
  Widget build(BuildContext context) {
    return OnBoardingUI(
      onChagned: _onChagned,
      onPress: _onPress,
      router: widget.router,
    );
  }

  String _checkInputs() {
    String error = '';
    if (_username.isEmpty) error = 'Enter display name';
    if (context.read<ProfileImageCubit>().state == null) {
      error = error.isEmpty
          ? '$error, Upload profile image'
          : 'Upload profile image';
    }
    return '$error';
  }

  void _onChagned(String value) => _username = value;

  void _onPress() async {
    context.disableKeyBoard();
    final error = _checkInputs();
    if (error.isNotEmpty) {
      final Color errColor = isLight ? KColor.black : KColor.primary;
      final snackBar = SnackBar(
          content: Text(
        error,
        style: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: errColor,
        ),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    await _connectSession();
  }

  Future<void> _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    await context.read<OnboardingCubbit>().connect(_username, profileImage!);
  }
}
