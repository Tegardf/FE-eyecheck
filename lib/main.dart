import 'package:eyecheckv2/controllers/classification_controlller.dart';
import 'package:eyecheckv2/controllers/user_controller.dart';
import 'package:eyecheckv2/screens/widget/initializer_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(ClassificationController());
  Get.put(UserController());

  runApp(const GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: InitializerScreen(),
    // home: ClassificationScreen(),
  ));
}
