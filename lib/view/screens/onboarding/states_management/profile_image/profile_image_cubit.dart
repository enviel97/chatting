import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageCubit extends Cubit<File?> {
  final _picker = ImagePicker();

  ProfileImageCubit() : super(null);

  Future<void> getImage() async {
    final PickedFile? image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 70);
    if (image == null) return null;
    emit(File(image.path));
  }
}
