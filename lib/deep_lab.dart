import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

class DeepLab {
  static const String deeplabv3 = "DeepLabv3";

  static void loadModel() async {
    Tflite.close();
    try {
      String? res;
      res = await Tflite.loadModel(
          model: 'assets/tflite/deeplabv3_257_mv_gpu.tflite',
          // model: 'assets/tflite/object_labeler.tflite',
          labels: 'assets/tflite/deeplabv3_257_mv_gpu.txt');
      log("YAY");
    } catch (e) {
      log(e.toString());
    }
  }

  static Future<Uint8List> predictImage(File image) async {
    Uint8List imaged = await performSegmentation(image);
    return imaged;
  }

  static List<int> newcolor = [
    //  Change color here
    const Color.fromARGB(0, 0, 0, 0).value, // background
    const Color.fromARGB(255, 128, 0, 0).value, // aeroplane
    const Color.fromARGB(255, 0, 128, 0).value, // biyclce
    const Color.fromARGB(255, 128, 128, 0).value, // bird
    const Color.fromARGB(255, 0, 0, 128).value, // boat
    const Color.fromARGB(255, 128, 0, 128).value, // bottle
    const Color.fromARGB(255, 0, 128, 128).value, // bus
    const Color.fromARGB(255, 128, 128, 128).value, // car
    const Color.fromARGB(255, 64, 0, 0).value, // cat
    const Color.fromARGB(255, 192, 0, 0).value, // chair
    const Color.fromARGB(255, 64, 128, 0).value, // cow
    const Color.fromARGB(255, 192, 128, 0).value, // diningtable
    const Color.fromARGB(255, 64, 0, 128).value, // dog
    const Color.fromARGB(255, 192, 0, 128).value, // horse
    const Color.fromARGB(255, 64, 128, 128).value, // motorbike
    const Color.fromARGB(255, 0, 0, 0).value, // person
    const Color.fromARGB(255, 0, 64, 0).value, // potted plant
    const Color.fromARGB(255, 128, 64, 0).value, // sheep
    const Color.fromARGB(255, 0, 192, 0).value, // sofa
    const Color.fromARGB(255, 128, 192, 0).value, // train
    const Color.fromARGB(255, 0, 64, 128).value, // tv-monitor
  ];

  static Future<Uint8List> performSegmentation(File image) async {
    Uint8List? recognition = await Tflite.runSegmentationOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      outputType: "png",
      labelColors: newcolor,
      asynch: true,
    );

    return recognition!;
  }
}
