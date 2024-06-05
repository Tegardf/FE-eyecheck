import 'package:eyecheckv2/controllers/user_controller.dart';
import 'package:eyecheckv2/screens/cam/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PatientForm extends StatefulWidget {
  const PatientForm({super.key});

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  // UserController userController = Get.put(UserController());
  UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: userController.namaPasien,
            decoration: const InputDecoration(labelText: 'Nama Pasien'),
            onChanged: (value) {
              userController.namaPasien.text = value;
            },
          ),
          TextField(
            controller: userController.dateOfBirth,
            decoration: const InputDecoration(
              labelText: 'Tanggal Lahir',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: Colors.blue,
                        colorScheme:
                            const ColorScheme.light(primary: Colors.blue),
                        buttonTheme: const ButtonThemeData(
                          textTheme: ButtonTextTheme.primary,
                        ),
                      ),
                      child: child!);
                },
              );
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                userController.dateOfBirth.text = formattedDate;
                // userController.dateOfBirth.value = formattedDate;
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              userController.addNewRecord();
              Get.off(const CameraScreen());
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
