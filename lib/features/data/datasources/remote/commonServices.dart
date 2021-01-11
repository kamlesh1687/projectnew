import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class CommonServices {
  CommonServices();
  Future<String> uploadImg(
      String _userId, File _fileImage, Reference _ref) async {
    UploadTask snapshot = _ref.putFile(_fileImage);
    TaskSnapshot taskSnapshot = await snapshot.whenComplete(() => null);
    String _url = await taskSnapshot.ref.getDownloadURL();
    return _url;
  }
}
