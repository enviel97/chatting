import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger_app/root/routes/onboarding_router.dart';
import 'package:messenger_app/view/constants/colors.dart';
import 'package:messenger_app/view/extention/context_extentions.dart';
import 'package:messenger_app/view/screens/onboarding/states_management/onboarding/onboarding_cubit.dart';
import 'package:messenger_app/view/widgets/custom_elevated_button.dart';
import 'package:messenger_app/view/widgets/custom_text_field.dart';
import 'package:messenger_app/view/screens/onboarding/part_ui/widgets/logo_row.dart';
import 'package:messenger_app/view/screens/onboarding/part_ui/widgets/profile_upload.dart';

const double _size = 45.0;

class OnBoardingUI extends StatefulWidget {
  final IOnboardingRouter router;

  final Function() onPress;

  final Function(String val) onChagned;

  const OnBoardingUI({
    Key? key,
    required this.router,
    required this.onPress,
    required this.onChagned,
  }) : super(key: key);

  @override
  _OnBoardingUIState createState() => _OnBoardingUIState();
}

class _OnBoardingUIState extends State<OnBoardingUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KColor.none,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: context.heightScreens,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const LogoRow(),
              const Spacer(),
              const ProfileUpload(),
              const Spacer(flex: 1),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  hint: 'What your name?',
                  height: _size,
                  onChanged: widget.onChagned,
                  inputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: CustomElevatedButton(
                  onPress: widget.onPress,
                  value: 'Make we chat!',
                ),
              ),
              const Spacer(flex: 1),
              BlocConsumer<OnboardingCubbit, OnboardingState>(
                builder: (BuildContext context, OnboardingState state) =>
                    state is Loading ? _buildLoading() : _buildEmpty(),
                listener: (_, state) {
                  if (state is OnboardingSuccess) {
                    widget.router.onSesstionSuccess(context, state.user);
                  }
                  if (state is OnboardingFail) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(state.error,
                          style: TextStyle(color: KColor.lightPrimary)),
                    ));
                  }
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildEmpty() => Container();

  Center _buildLoading() =>
      Center(child: CircularProgressIndicator(color: KColor.primary));
}
