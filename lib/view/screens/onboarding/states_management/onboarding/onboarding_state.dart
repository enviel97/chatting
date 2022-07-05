part of './onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
}

class OnboardingInitial extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class Loading extends OnboardingState {
  @override
  List<Object?> get props => [];
}

class OnboardingFail extends OnboardingState {
  final String error;
  const OnboardingFail(this.error);

  @override
  List<Object?> get props => [error];
}

class OnboardingSuccess extends OnboardingState {
  final User user;

  const OnboardingSuccess(this.user);

  @override
  List<Object?> get props => [user];
}
