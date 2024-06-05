import 'dart:convert';
import 'package:eyecheckv2/controllers/classification_controlller.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:eyecheckv2/utils/medical_record_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String imgViewUrl(String imgName) {
  return ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.imgURl + imgName;
}

class UserController extends GetxController {
  var name = ''.obs;
  // var role = ''.obs;
  var age = 0.obs;
  var doB = ''.obs;
  var medicalRecords = <MedicalRecord>[].obs;

  var agePtient = 0.obs;

  TextEditingController namaPasien = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();

  // final ClassificationController classificationController =
  //     // Get.put(ClassificationController());

  var errorMsg = ''.obs;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // @override
  // void onInit() async {
  //   super.onInit();
  //   bool stateProfil = await fetchUserData();
  //   if (stateProfil) {
  //     fetchMedicalRecord();
  //   }
  // }
  void fetchAll() async {
    bool stateProfil = await fetchUserData();
    if (stateProfil) {
      fetchMedicalRecord();
    }
  }
  // void setRole(String newRole) {
  //   role.value = newRole;
  // }

  Future<bool> fetchUserData() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.get('token');
    final role = prefs.get('role');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };
    try {
      var endpoint = '';
      if (role == 'dokter') {
        endpoint = ApiEndPoints.authEndpoints.userDokterData;
      } else if (role == 'pasien') {
        endpoint = ApiEndPoints.authEndpoints.userPasienData;
      }
      var url = Uri.parse(ApiEndPoints.baseUrl + endpoint);
      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        DateTime birthDate = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
            .parse(json['tgl_lahir']);
        doB.value = DateFormat("yyyy-MM-dd").format(birthDate);
        DateTime today = DateTime.now();
        int years = today.year - birthDate.year;
        int months = today.month - birthDate.month;
        int days = today.day - birthDate.day;
        if (months < 0 || (months == 0 && days < 0)) {
          years--;
        }
        // print(json['nama_lengkap']);
        // print(years);
        name.value = json['nama_lengkap'];
        age.value = years;
        return true;
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      errorMsg.value = error.toString();
      print(error);
      return false;
    }
  }

  void fetchMedicalRecord() async {
    final SharedPreferences prefs = await _prefs;
    final token = prefs.get('token');
    final role = prefs.get('role');

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $token"
    };
    try {
      var endpoint = '';
      if (role == 'dokter') {
        endpoint = ApiEndPoints.authEndpoints.allRekamanDokter;
      } else if (role == 'pasien') {
        endpoint = ApiEndPoints.authEndpoints.allRekamanPasien;
      }
      var url = Uri.parse(ApiEndPoints.baseUrl + endpoint);
      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // print(json.length);
        for (var i = 0; i < json.length; i++) {
          medicalRecords.add(MedicalRecord.fromJson(json[i]));
        }
        print(medicalRecords.length);
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      errorMsg.value = error.toString();
      print('error bang: $error');
    }
  }

  Future<void> addNewRecord() async {
    DateTime dob = DateTime.parse(dateOfBirth.text);
    DateTime now = DateTime.now();
    int ageNew = now.year - dob.year;
    // Check if the birthday has occurred this year
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      ageNew--;
    }
    // print('Calculated Age: $ageNew');
    final ClassificationController classificationController =
        Get.find<ClassificationController>();
    if (ageNew > 50) {
      classificationController.cfValues[13] = 1.0;
      classificationController.cfValues[14] = 0.0;
    } else {
      classificationController.cfValues[13] = 0.0;
      classificationController.cfValues[14] = 1.0;
    }

    final SharedPreferences prefs = await _prefs;
    final role = prefs.get('role');
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${prefs.getString('token')}',
    };
    Uri url;
    var body = {
      'nama_pasien': namaPasien.text,
      'tgl_lahir_pasien': dateOfBirth.text,
    };
    if (role == 'dokter') {
      url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.addDataDokter);
    } else if (role == 'pasien') {
      url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.addDataPasien);
    } else {
      errorMsg.value = 'Invalid role';
      return;
    }
    try {
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 200) {
        print('suceesss');
        final json = jsonDecode(response.body);
        // print(json['id']);
        final SharedPreferences prefs = await _prefs;
        await prefs.setInt('id_rekams', json['id']);
        namaPasien.clear();
        dateOfBirth.clear();
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      errorMsg.value = error.toString();
    }
  }
}
