import 'package:eyecheckv2/controllers/classification_controlller.dart';
// import 'package:eyecheckv2/controllers/user_controller.dart';
import 'package:eyecheckv2/screens/quizioner/widget/keluhan_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClassificationScreen extends StatelessWidget {
  ClassificationScreen({super.key});
  final List<String> symptoms = [
    "Penglihatan Rabun",
    "Sensitif kepada cahaya langsung",
    "Pengelihatan ganda",
    "Pengelihatan Berkabut",
    "Sakit pada mata",
    "Pengelihatan Lebih nyaman pada sore hari / lebih nyaman pada ruangan redup",
    "Terdapat lingkaran putih saat melihat ke cahaya",
    "Pengelihatan tehadap warna menurun",
    "Sering ganti ukuran kacamata",
    "Pernah cedera pada bola mata",
    "Benturan pada area sekitar mata",
    "Memiliki riwayat diabetes",
    "Penggunaan steroid jangka panjang / meminum obat yang tidak terdaftar",
    "Lama kejadian keluhan, satu sampai 10 tahun",
  ];

  final ClassificationController classificationController =
      Get.find<ClassificationController>();
  // final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Kuisioner Keluhan',
            style: TextStyle(
              fontSize: 20, // You can adjust the font size as needed
              fontWeight:
                  FontWeight.bold, // You can adjust the font weight as needed
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Obx(() => KeluhanScreen(
                keluhan: symptoms[classificationController.count.value],
                index: classificationController.count.value)),
            const SizedBox(height: 20),
            Obx(
              () => classificationController.count.value == symptoms.length - 1
                  ? ElevatedButton(
                      onPressed: () async {
                        print('test:${classificationController.cfValues}');
                        await classificationController.klasifikasi();
                      },
                      child: const Text("Send"),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        classificationController.increment();
                      },
                      child: const Text("Next"),
                    ),
            )
          ],
        ));
  }
}
