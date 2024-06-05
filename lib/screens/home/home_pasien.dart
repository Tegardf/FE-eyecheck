// import 'package:eyecheckv2/controllers/result_controller.dart';
import 'package:eyecheckv2/controllers/user_controller.dart';
import 'package:eyecheckv2/screens/cam/camera_screen.dart';
import 'package:eyecheckv2/screens/home/widget/medical_record_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/auth_screen.dart';

class HomeScreenPasien extends StatefulWidget {
  const HomeScreenPasien({Key? key}) : super(key: key);

  @override
  State<HomeScreenPasien> createState() => _HomeScreenPasienState();
}

class _HomeScreenPasienState extends State<HomeScreenPasien> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // final UserController userController = Get.put(UserController());
  // final ResultController resultController = Get.put(ResultController());
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    userController.fetchAll();
    // userController.setRole('pasien');
    // resultController.setRole('pasien');
    // print(resultController.role.value);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.logout,
            size: 30,
            weight: 900,
            color: Colors.white,
          ),
          onPressed: () async {
            final SharedPreferences prefs = await _prefs;
            prefs.clear();
            Get.offAll(const AuthScreen());
          },
        ),
        title: const Text(
          'Home Page',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                        child: Text(
                          "Selamat Datang di Aplikasi \nEyecheck",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 80),
                      Obx(
                        () => Row(
                          children: [
                            const Text(
                              'Nama',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                ': ${userController.name.value}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => Row(
                          children: [
                            const Text(
                              'Umur',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                ': ${userController.age.value}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 1.0,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Obx(
                () {
                  if (userController.medicalRecords.isEmpty) {
                    return const SliverToBoxAdapter(
                      child:
                          Center(child: Text("No Medical Records Available")),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Column(
                            children: [
                              MedicalRecordTile(
                                isPasien: true,
                                recordTilteName:
                                    userController.medicalRecords[index].name,
                                recordTilteTime: userController
                                    .medicalRecords[index].tglCheck,
                                medicalRecord:
                                    userController.medicalRecords[index],
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                        childCount: userController.medicalRecords.length,
                      ),
                    );
                  }
                },
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 95, // Adjust the height to provide the desired space
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 10, // Blur radius
                      offset: const Offset(0, 5), // Offset of the shadow
                    ),
                  ],
                ),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: FloatingActionButton(
                    onPressed: () {
                      userController.dateOfBirth.text =
                          userController.doB.value;
                      userController.namaPasien.text =
                          userController.name.value;
                      userController.addNewRecord();
                      Get.off(const CameraScreen());
                    },
                    backgroundColor: Colors.blueAccent,
                    elevation: 8,
                    mini: false,
                    shape: const CircleBorder(),
                    child: const Icon(
                      Icons.remove_red_eye,
                      size: 40, // Eye icon
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
