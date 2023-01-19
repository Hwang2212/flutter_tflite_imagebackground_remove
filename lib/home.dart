import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/deep_lab.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widget_mask/widget_mask.dart';

import 'image_picker_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NavigatorState get navigatorState => Navigator.of(context);
  File? _profilePic;
  Uint8List? finalPic;
  double? _imageWidth;
  double? _imageHeight;

  @override
  void initState() {
    super.initState();
    DeepLab.loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildProfilePicture(),
              buildCameraButton(),
              buildGalleryButton(),
              // buildFinalPic(),
              buildStackImage()
            ],
          ),
        ),
      ),
    );
  }

  buildProfilePicture() {
    if (_profilePic != null) {
      return Image.file(
        _profilePic!,
        fit: BoxFit.fill,
        height: 500,
        // width: 300,
      );
    }
    return const Icon(
      Icons.camera,
      size: 200,
    );
  }

  buildFinalPic() {
    if (finalPic != null) {
      return Image.memory(
        finalPic!,
        // fit: BoxFit.fitHeight,
        width: _imageWidth,
        height: _imageHeight,
      );
    }
    return const SizedBox.shrink();
  }

  buildStackImage() {
    return (_profilePic != null && finalPic != null)
        ? WidgetMask(
            blendMode: BlendMode.srcATop,
            childSaveLayer: true,
            mask: Image.file(
              _profilePic!,
              fit: BoxFit.fill,
            ),
            child: Image.memory(
              finalPic!,
              color: Colors.black.withOpacity(1.0),
              fit: BoxFit.fill,
            ),
          )
        : const SizedBox.shrink();
  }

  buildCameraButton() {
    return ElevatedButton(onPressed: useCamera, child: const Text("Camera"));
  }

  buildGalleryButton() {
    return ElevatedButton(onPressed: useGallery, child: const Text("Gallery"));
  }

  void useCamera() async {
    File? cameraPicture =
        await ImagePickerService().pickImage(ImageSource.camera) ?? _profilePic;
    FileImage(cameraPicture!)
        .resolve(const ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));
    finalPic = await DeepLab.predictImage(cameraPicture);

    setState(() async {
      cameraPicture ??= _profilePic;
      _profilePic = cameraPicture;
    });
  }

  void useGallery() async {
    File? galleryPicture =
        await ImagePickerService().pickImage(ImageSource.gallery) ??
            _profilePic;

    FileImage(galleryPicture!)
        .resolve(const ImageConfiguration())
        .addListener((ImageStreamListener((ImageInfo info, bool _) {
          setState(() {
            _imageWidth = info.image.width.toDouble();
            _imageHeight = info.image.height.toDouble();
          });
        })));

    finalPic = await DeepLab.predictImage(galleryPicture);
    // File("test.png").writeAsBytes(finalPic!);
    setState(() {
      galleryPicture ??= _profilePic;
      _profilePic = galleryPicture;
    });
  }
}
