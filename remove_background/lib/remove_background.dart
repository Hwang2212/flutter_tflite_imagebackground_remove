library remove_background;

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' show Color;
import 'package:flutter/services.dart';

/// A Calculator.
class RemoveBackground {
  static const MethodChannel _channel = MethodChannel('removebackground');

  static Future<String?> loadModel(
      {required String model,
      String labels = "",
      int numThreads = 1,
      bool isAsset = true,
      bool useGpuDelegate = false}) async {
    return await _channel.invokeMethod(
      'loadModel',
      {
        "model": model,
        "labels": labels,
        "numThreads": numThreads,
        "isAsset": isAsset,
        'useGpuDelegate': useGpuDelegate
      },
    );
  }
}
