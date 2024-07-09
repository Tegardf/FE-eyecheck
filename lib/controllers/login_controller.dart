import 'dart:convert';

import 'package:eyecheckv2/screens/home/home.dart';
import 'package:eyecheckv2/screens/home/home_pasien.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var passwordObscure = true.obs;
  var isFormValid = false.obs;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void onInit() {
    super.onInit();
    usernameController.addListener(validateForm);
    passwordController.addListener(validateForm);
  }

  void togglePasswordVisibility() {
    passwordObscure.value = !passwordObscure.value;
  }

  void validateForm() {
    isFormValid.value = formKey.currentState?.validate() ?? false;
  }

  Future<void> login() async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.loginEmail);
      Map body = {
        'username': usernameController.text.trim(),
        'password': passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print(json);
        var token = json['token'];
        var role = json['role'];
        final SharedPreferences prefs = await _prefs;
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        usernameController.clear();
        passwordController.clear();
        if (role == 'dokter') {
          Get.off(HomeScreen());
        } else if (role == 'pasien') {
          Get.off(const HomeScreenPasien());
        }
      } else {
        throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
      }
    } catch (error) {
      Get.back();
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }
}
