import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

final class ImageUtil {
  static String getProfileImagePath(String id) {
    return "member/$id/profile.png";
  }

  static Future<String> uploadImage(XFile image, String path) async {
    var file = File(image.path);

    var ref = FirebaseStorage.instance.ref().child(path);
    var task = await ref.putFile(file);
    return task.ref.getDownloadURL();
  }

  static Future<String> uploadDefaultImage(String path) async {
    var byteData = await rootBundle.load("assets/profile/profile.png");
    var bytes = byteData.buffer.asUint8List();

    var task = await FirebaseStorage.instance.ref(path).putData(bytes);
    return task.ref.getDownloadURL();
  }
}
