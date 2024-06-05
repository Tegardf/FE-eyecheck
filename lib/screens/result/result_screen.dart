import 'package:eyecheckv2/controllers/detection_controller.dart';
import 'package:eyecheckv2/controllers/result_controller.dart';
import 'package:eyecheckv2/screens/home/home.dart';
import 'package:eyecheckv2/screens/home/home_pasien.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({Key? key}) : super(key: key);

  final DetectionController detectionController =
      Get.put(DetectionController());
  final ResultController resultController = Get.put(ResultController());
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    resultController.resultById();
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Result Screen',
            style: TextStyle(
              fontSize: 20, // You can adjust the font size as needed
              fontWeight:
                  FontWeight.bold, // You can adjust the font weight as needed
            ),
          ),
          automaticallyImplyLeading: false, // This removes the back button
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Center(
                        child: Text(
                          'gambar mata',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Image.network(
                          "${ApiEndPoints.baseUrl}image${resultController.medicalRecords.value.pictureUrl}",
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                          'Name: ${resultController.medicalRecords.value.name}'),
                      // const SizedBox(height: 10),
                      // Text('Umur: $umur'),
                      const SizedBox(height: 10),
                      // Text('Waktu Deteksi: $waktuDeteksi'),
                      // const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Status Deteksi: ${resultController.medicalRecords.value.gejala['Lensa keruh']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      resultController.medicalRecords.value.jenisKatarak == null
                          ? const SizedBox(height: 0)
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Jenis Katarak: ${resultController.medicalRecords.value.jenisKatarak}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(height: 10),
                      resultController.medicalRecords.value
                                  .percentageExpertSystem ==
                              null
                          ? const SizedBox(height: 0)
                          : Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Percentage Expert System: ${resultController.medicalRecords.value.percentageExpertSystem?.toStringAsFixed(2)}%',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      const SizedBox(height: 10),
                      resultController.medicalRecords.value.jenisKatarak == null
                          ? const SizedBox(height: 0)
                          : const Text('Keluhan - keluhan:'),
                      const SizedBox(height: 10),
                      resultController.medicalRecords.value.jenisKatarak == null
                          ? const SizedBox(height: 0)
                          : Column(
                              children: resultController
                                  .medicalRecords.value.gejala.entries
                                  .take(resultController.medicalRecords.value
                                          .gejala.entries.length -
                                      1)
                                  .map((entry) {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        // Set your desired default text style here
                                        color: Colors.black, // Example color
                                        fontSize: 15.0, // Example font size
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '- ${entry.key}: ',
                                          // style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text: '${entry.value ?? "N/A"}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                      const SizedBox(height: 95),
                    ],
                  ),
                ),
              ),
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
                      onPressed: () async {
                        final SharedPreferences prefs = await _prefs;
                        final role = prefs.get('role');
                        if (role == 'dokter') {
                          Get.off(() => const HomeScreen());
                        } else if (role == 'pasien') {
                          Get.off(() => const HomeScreenPasien());
                        }
                      },
                      backgroundColor: Colors.blueAccent,
                      elevation: 8,
                      mini: false,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.home,
                        size: 40, // Eye icon
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
