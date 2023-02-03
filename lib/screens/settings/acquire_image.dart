import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AcquireImage {

  static AcquireImage _acquireImage = AcquireImage._AcquireImageConstructor();

  factory AcquireImage() =>
      _acquireImage ??= AcquireImage._AcquireImageConstructor();

  AcquireImage._AcquireImageConstructor();

  Future<String?> getImageFromCamera() async {
    XFile? imagePicked = await ImagePicker().pickImage(
        source: ImageSource.camera);
    if (imagePicked != null){
      File file = File(imagePicked.path);
      return file.path;
    }
    return null;
  }

}