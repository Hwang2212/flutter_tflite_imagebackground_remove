import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'dart:io';

ImagePicker _imagePicker = ImagePicker();

class ImagePickerService {
  Future pickImage(ImageSource imageSource) async {
    File? image;

    try {
      // if (image == null) return;

      XFile? file = await _imagePicker.pickImage(source: imageSource);
      if (file == null) {
        return;
      } else {
        image = File(file.path);
        return image;
      }
    } catch (e) {
      log("Test ${e.toString()}");
      return e;
    }
  }
}
