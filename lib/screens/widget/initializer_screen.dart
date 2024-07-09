import 'dart:convert';

import 'package:eyecheckv2/screens/auth/auth_screen.dart';
import 'package:eyecheckv2/screens/home/home.dart';
import 'package:eyecheckv2/screens/home/home_pasien.dart';
import 'package:eyecheckv2/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InitializerScreen extends StatelessWidget {
  const InitializerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _checkToken();
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  void _checkToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      Get.off(() => const AuthScreen());
    } else {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $token"
      };
      try {
        var url = Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.checkRole);
        http.Response response = await http.get(url, headers: headers);
        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          if (json['role'] == 'dokter') {
            prefs.setString('role', 'dokter');
            Get.off(() => HomeScreen());
          } else if (json['role'] == 'pasien') {
            prefs.setString('role', 'pasien');
            Get.off(() => const HomeScreenPasien());
          }
        } else if (response.statusCode == 407) {
          Get.off(() => const AuthScreen());
        } else {
          throw jsonDecode(response.body)["message"] ?? "Unknown Error Occured";
        }
      } catch (error) {
        print(error.toString());
      }
    }
  }
}
