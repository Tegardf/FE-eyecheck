import 'dart:convert';
// import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

// import 'package:eyecheckv2/screens/cam/crop_img_screen.dart';
import 'package:eyecheckv2/screens/cam/picture_preview_screen.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image/image.dart' as img;

class CameraManager extends GetxController {
  late CameraController cameraController;
  late CameraDescription cameraDescription;
  var isCameraInitialized = false.obs;
  var picture = Rxn<XFile?>(null);
  var flashModeSelected = false.obs;
  var errorMsg = ''.obs;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void onInit() {
    super.onInit();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      cameraDescription = cameras[0];
      cameraController =
          CameraController(cameraDescription, ResolutionPreset.max);
      await cameraController.initialize();
      isCameraInitialized.value = true;
      await cameraController.setFocusMode(FocusMode.values.first);
    } catch (e) {
      print('Error Initializing camera: $e');
    }
  }

  Future<void> takePicture() async {
    if (!cameraController.value.isInitialized) {
      return;
    }
    if (cameraController.value.isTakingPicture) {
      return;
    }
    try {
      XFile newPict = await cameraController.takePicture();
      picture.value = newPict;
      await cropImg();
      Get.to(() => PreviewPage());
    } on CameraException catch (e) {
      debugPrint('Error occurred while taking picture: $e');
    }
  }

  Future<bool> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      picture.value = image;
      // Get.to(() => CropImgScreen());
      return true;
    }
    return false;
  }

  Future<void> focusOnPoint(TapDownDetails details) async {
    if (!cameraController.value.isInitialized) {
      return;
    }
    if (cameraController.value.previewSize == null) {
      print('Preview size is null');
      return;
    }

    try {
      final Offset offset = details.globalPosition;
      final ui.Size previewSize = cameraController.value.previewSize!;
      final double dx = offset.dx / previewSize.width;
      final double dy = offset.dy / previewSize.height;

      final double px = dx.clamp(0.0, 1.0);
      final double py = dy.clamp(0.0, 1.0);

      await cameraController.setFocusPoint(Offset(px, py));
    } catch (e) {
      print('Focus failed: $e');
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  void toggleFlashMode() async {
    flashModeSelected.value = !flashModeSelected.value;
    if (flashModeSelected.value) {
      await cameraController.setFlashMode(FlashMode.torch);
    } else {
      await cameraController.setFlashMode(FlashMode.off);
    }
  }

  Future<bool> upImage() async {
    final SharedPreferences prefs = await _prefs;
    final idRekam = prefs.get('id_rekams');
    final token = prefs.get('token');
    var url = ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.upImg;
    var request = http.MultipartRequest("POST", Uri.parse(url));
    File file = File(picture.value!.path);
    var headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': "Bearer $token",
      'Idrekam': "$idRekam"
    };
    request.files.add(
      http.MultipartFile(
        'image',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: 'eye image',
      ),
    );
    try {
      request.headers.addAll(headers);
      var response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final json = jsonDecode(responseBody);
        print(json);
        return (true);
      } else {
        throw jsonDecode(response.toString())["message"] ??
            "Unknown Error Occured";
      }
    } catch (error) {
      errorMsg.value = error.toString();
      return (false);
    }
  }

  Future<void> cropImg() async {
    if (picture.value != null) {
      final Uint8List imageData = await picture.value!.readAsBytes();
      img.Image? originalImg = img.decodeImage(imageData);

      if (originalImg != null) {
        int cropSize = 500;
        int offsetX = (originalImg.width - cropSize) ~/ 2;
        int offsetY = (originalImg.height - cropSize) ~/ 2;

        img.Image croppedImg = img.copyCrop(
          originalImg,
          x: offsetX,
          y: offsetY,
          width: cropSize,
          height: cropSize,
        );
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        String fileName = 'cropped_image_$timestamp.jpg';

        List<int> croppedImageData = img.encodeJpg(croppedImg);
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;

        File outputFile = File('$tempPath/$fileName');
        await outputFile.writeAsBytes(croppedImageData);

        picture.value = XFile(outputFile.path);
      }
    }
  }

  Future<void> manualCropImg() async {
    try {
      if (picture.value != null) {
        CroppedFile? cropedFile = await ImageCropper().cropImage(
          sourcePath: picture.value!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Crop Image',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              statusBarColor: Colors.blue,
              activeControlsWidgetColor: Colors.blue,
              cropFrameColor: Colors.blue,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true,
            ),
          ],
        );
        if (cropedFile != null) {
          picture.value = XFile(cropedFile.path);
          Get.to(PreviewPage());
        }
      }
    } catch (e) {
      errorMsg.value = e.toString();
    }
  }
}
