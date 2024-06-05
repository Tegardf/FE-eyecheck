import 'dart:io';

import 'package:eyecheckv2/controllers/camera_controller.dart';
import 'package:eyecheckv2/controllers/detection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewPage extends StatelessWidget {
  PreviewPage({super.key});

  final CameraManager cameraManager = Get.put(CameraManager());
  final DetectionController detectionController =
      Get.put(DetectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Preview Picture')),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(File(cameraManager.picture.value!.path),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    bool upState = await cameraManager.upImage();
                    if (upState) {
                      detectionController.deteksi();
                    }
                  },
                  child: const Text('Upload Image'),
                ),
              ],
            ),
          ),
        ));
  }
}
