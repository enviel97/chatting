import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:messenger_app/cache/local_cache.dart';
import 'package:messenger_app/data/services/image_upload.dart';
import 'package:service/chat.dart';

part 'onboarding_state.dart';

class OnboardingCubbit extends Cubit<OnboardingState> {
  final IUserService _userService;
  final ImageUploader _imageUploader;
  final ILocalCache _localCache;

  OnboardingCubbit(this._userService, this._imageUploader, this._localCache)
      : super(OnboardingInitial());

  Future<void> connect(String name, File profileImage) async {
    emit(Loading());

    final url = await _imageUploader.uploadImage(profileImage);
    if (url.isNotEmpty) {
      final user = User(
        username: name,
        photoUrl: url,
        lastseen: DateTime.now(),
        active: true,
      );
      final createdUser = await _userService.connect(user);
      final userJson = {
        'username': createdUser.username,
        'active': true,
        'photo_url': createdUser.photoUrl,
        'id': createdUser.id,
      };

      await _localCache.save('USER', userJson);

      emit(OnboardingSuccess(createdUser));
      return;
    }

    emit(OnboardingFail('Something wrong, please try again'));
  }
}
