import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AcquireImage {

  static AcquireImage _acquireImage = AcquireImage._AcquireImageConstructor();

  factory AcquireImage() =>
      _acquireImage ??= AcquireImage._AcquireImageConstructor();

  AcquireImage._AcquireImageConstructor();

  Future<XFile?> getImageFromCamera() async {
    XFile? imagePicked = await ImagePicker().pickImage(
        source: ImageSource.camera);
    if (imagePicked != null) {
      return imagePicked;
    }
    return null;
  }

  Future<XFile?> initializeFile()async{
    return null;
  }

}