import 'package:camera/camera.dart';
import 'package:eyecheckv2/controllers/camera_controller.dart';
import 'package:eyecheckv2/screens/cam/widget/square_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CameraManager cameraManager = Get.put(CameraManager());
    const double overlaySize = 200;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Obx(
          () {
            if (cameraManager.isCameraInitialized.value) {
              return GestureDetector(
                onTapDown: (details) => cameraManager.focusOnPoint(details),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CameraPreview(cameraManager.cameraController),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: SquareOverlay(size: overlaySize),
                    ),
                    Positioned(
                      bottom: 50,
                      left: 20,
                      child: IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: () async {
                          bool stateImg =
                              await cameraManager.pickImageFromGallery();
                          if (stateImg) {
                            await cameraManager.manualCropImg();
                          } else {
                            Get.snackbar('Error',
                                'Failed to pick image: ${cameraManager.errorMsg}');
                          }
                        },
                        iconSize: 36,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      left: MediaQuery.of(context).size.width / 2 - 18,
                      child: IconButton(
                        icon: const Icon(Icons.camera),
                        onPressed: () async {
                          await cameraManager.takePicture();
                        },
                        iconSize: 36,
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      right: 20,
                      child: IconButton(
                        icon: Icon(cameraManager.flashModeSelected.value
                            ? Icons.flash_on
                            : Icons.flash_off),
                        onPressed: () {
                          cameraManager.toggleFlashMode();
                        },
                        iconSize: 36,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
