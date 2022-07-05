import 'dart:io';

import 'package:http/http.dart';

class ImageUploader {
  final String _url;
  const ImageUploader(this._url);

  Future<String> uploadImage(File image) async {
    final request = MultipartRequest('POST', Uri.parse(_url));
    request.files.add(await MultipartFile.fromPath('picture', image.path));

    final result = await request.send();
    if (result.statusCode != 200) {
      print('image_service have error: ${result.statusCode}\nmess: $result');
      return '';
    }

    final response = await Response.fromStream(result);
    return "http://localhost:3000${response.body}";
  }
}
