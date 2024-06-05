import 'dart:convert';

import 'package:eyecheckv2/screens/home/home.dart';
import 'package:eyecheckv2/screens/home/home_pasien.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterationController extends GetxController {
  final formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController validatepasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController tglController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var passwordObscure = true.obs;
  var passwordValidObscure = true.obs;
  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    usernameController.addListener(validateForm);
    passwordController.addListener(validateForm);
    nameController.addListener(validateForm);
    tglController.addListener(validateForm);
  }

  void togglePasswordVisibility() {
    passwordObscure.value = !passwordObscure.value;
  }

  void togglePasswordValidateVisibility() {
    passwordValidObscure.value = !passwordValidObscure.value;
  }

  void validateForm() {
    isFormValid.value = formKey.currentState?.validate() ?? false;
  }

  Future<void> register() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.registerEmail);
      Map body = {
        'username': usernameController.text.trim(),
        'role': 'dokter',
        'password': passwordController.text,
        "namaLengkap": nameController.text,
        "tglLahir": tglController.text
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        var token = json['token'];
        print(token);
        final SharedPreferences prefs = await _prefs;
        await prefs.setString('token', token);
        usernameController.clear();
        passwordController.clear();
        nameController.clear();
        tglController.clear();
        var role = json['role'];
        if (role == 'dokter') {
          Get.off(const HomeScreen());
        } else if (role == 'pasien') {
          Get.off(const HomeScreenPasien());
        }
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
      }
    } catch (e) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(e.toString())],
            );
          });
    }
  }
}
