import 'dart:convert';
// import 'package:eyecheckv2/screens/home/home.dart';
// import 'package:eyecheckv2/screens/home/home_pasien.dart';
import 'package:eyecheckv2/utils/medical_record_model.dart';
// import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var medicalRecords = MedicalRecord(
    gejala: {},
    id: 0,
    jenisKatarak: '',
    name: '',
    percentageExpertSystem: 0.0,
    pictureUrl: '',
    tglCheck: '',
    umur: 0,
  ).obs;
  // var role = ''.obs;
  var errorMsg = ''.obs;

  // void setRole(String newRole) {
  //   role.value = newRole;
  // }

  void resultById() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.get('token');
    final idRekam = prefs.get('id_rekams');
    final role = prefs.get('role');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };
    try {
      var endpoint = '';
      print(role);
      if (role == 'dokter') {
        endpoint = ApiEndPoints.authEndpoints.rekamanDokter;
      } else if (role == 'pasien') {
        endpoint = ApiEndPoints.authEndpoints.rekamanPasien;
      }
      var url = Uri.parse("${ApiEndPoints.baseUrl}$endpoint?id=$idRekam");
      print(url);
      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json);
        medicalRecords(MedicalRecord.fromJson(json));
        print(medicalRecords);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      errorMsg.value = error.toString();
      print('error: $error');
      // return false;
    }
  }
}
