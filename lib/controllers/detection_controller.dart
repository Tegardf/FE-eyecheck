import 'dart:convert';
import 'package:eyecheckv2/screens/quizioner/classification_screen.dart';
import 'package:eyecheckv2/screens/result/result_screen.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetectionController extends GetxController {
  var statusKatarak = ''.obs;
  var runtimeDetection = ''.obs;

  var errorMsg = ''.obs;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> deteksi() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.get('token');
    final idRekam = prefs.get('id_rekams');
    // print(idRekam);
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token",
      'Idrekam': "$idRekam"
    };
    try {
      var url =
          Uri.parse(ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.deteksi);
      http.Response response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json);
        statusKatarak.value = json['Result'];
        runtimeDetection.value = json['runtime'];
        // print(runtimeDetection.value);
        if (statusKatarak.value == 'Normal') {
          Get.to(() => ResultScreen());
        } else if (statusKatarak.value == 'Katarak') {
          Get.to(() => ClassificationScreen());
        }
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      errorMsg.value = error.toString();
    }
  }
}
