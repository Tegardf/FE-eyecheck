import 'dart:convert';

import 'package:eyecheckv2/screens/result/result_screen.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClassificationController extends GetxController {
  var jenisKatarak = ''.obs;
  var persentaseKatark = 0.0.obs;
  RxList<double> cfValues = List<double>.filled(16, 0.0).obs;
  var count = 0.obs;

  var errorMsg = ''.obs;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void increment() {
    count++;
  }

  void updateValueCF(int index, double value) {
    if (count.value == 13) {
      cfValues[15] = value;
    } else {
      cfValues[index] = value;
    }
  }

  Future<void> klasifikasi() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.get('token');
    final idRekam = prefs.get('id_rekams');
    print(idRekam);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
      'Idrekam': "$idRekam"
    };
    var body = {
      'gejalas': cfValues,
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.klasifikasi);
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json);
        jenisKatarak.value = json['katarak'];
        persentaseKatark.value = json['persentase'];
        Get.to(() => ResultScreen());
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      errorMsg.value = error.toString();
      print("error: $error");
    }
  }

  Map<int, double> selectedValues = {};

  final List<String> choices = [
    "Sangat tidak",
    "Tidak",
    "Mungkin tidak",
    "Mungkin Iya",
    "Iya",
    "Pasti ya",
  ];

  final Map<String, double> customValues = {
    "Sangat tidak": 0.0,
    "Tidak": 0.2,
    "Mungkin tidak": 0.4,
    "Mungkin Iya": 0.6,
    "Iya": 0.8,
    "Pasti ya": 1.0,
  };

  void updateValue(int index, double value) {
    selectedValues[index] = value;
    update();
  }
}
