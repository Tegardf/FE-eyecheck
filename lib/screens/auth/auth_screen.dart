import 'package:eyecheckv2/controllers/login_controller.dart';
import 'package:eyecheckv2/controllers/registeration_controller.dart';
import 'package:eyecheckv2/controllers/user_controller.dart';
import 'package:eyecheckv2/screens/auth/widgets/app_text_form_field.dart';
import 'package:eyecheckv2/screens/auth/widgets/submit_button.dart';
import 'package:eyecheckv2/utils/app_regex.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  RegisterationController registerationController =
      Get.put(RegisterationController());
  // final UserController userController = Get.put(UserController());
  final UserController userController = Get.find<UserController>();

  LoginController loginController = Get.put(LoginController());

  var isLogin = true.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Center(
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  const Text(
                    'WELCOME',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  isLogin.value ? loginWidget() : registerWidget(),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin.value
                            ? 'Belum Memiliki Akun? '
                            : 'Sudah Memiliki Akun? ',
                        style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      InkWell(
                        onTap: () => isLogin.value = !isLogin.value,
                        child: Text(
                          isLogin.value ? 'Register' : "Login",
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget registerWidget() {
    return Form(
      key: registerationController.formKey,
      child: Column(
        children: [
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: 'Nama Lengkap',
            keyboardType: TextInputType.name,
            controller: registerationController.nameController,
            onChanged: (_) => registerationController.validateForm(),
            validator: (value) {
              return value!.isEmpty ? 'Please enter your full name' : null;
            },
          ),
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: 'Username',
            keyboardType: TextInputType.emailAddress,
            controller: registerationController.usernameController,
            onChanged: (_) => registerationController.validateForm(),
            validator: (value) {
              return value!.isEmpty ? 'Please enter username' : null;
            },
          ),
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: 'Tanggal Lahir',
            keyboardType: TextInputType.datetime,
            controller: registerationController.tglController,
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
                registerationController.tglController.text = formattedDate;
              }
            },
            onChanged: (_) => registerationController.validateForm(),
            validator: (value) {
              return value!.isEmpty ? 'Please enter Date of Birth' : null;
            },
          ),
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: 'Password',
            keyboardType: TextInputType.visiblePassword,
            controller: registerationController.passwordController,
            onChanged: (_) => registerationController.validateForm(),
            obscureText: registerationController.passwordObscure.value,
            validator: (value) {
              return value!.isEmpty
                  ? "Please Enter password"
                  : AppRegex.passRegex.hasMatch(value)
                      ? null
                      : "Invalid Password";
            },
            suffixIcon: IconButton(
              icon: Icon(
                registerationController.passwordObscure.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () =>
                  registerationController.togglePasswordVisibility(),
              style: IconButton.styleFrom(minimumSize: const Size.square(28)),
            ),
          ),
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: 'Validate Password',
            keyboardType: TextInputType.visiblePassword,
            controller: registerationController.validatepasswordController,
            obscureText: registerationController.passwordValidObscure.value,
            onChanged: (_) => registerationController.validateForm(),
            validator: (value) {
              return value == registerationController.passwordController.text
                  ? null
                  : 'Password does not match';
            },
            suffixIcon: IconButton(
              icon: Icon(
                registerationController.passwordValidObscure.value
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20,
                color: Colors.black,
              ),
              onPressed: () =>
                  registerationController.togglePasswordValidateVisibility(),
              style: IconButton.styleFrom(minimumSize: const Size.square(28)),
            ),
          ),
          const SizedBox(height: 40),
          SubmitButton(
            onPressed: () => registerationController.isFormValid.value
                ? registerationController.register()
                : null,
            title: 'Register',
          ),
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Form(
      key: loginController.formKey,
      child: Column(
        children: [
          AppTextFormField(
            textInputAction: TextInputAction.next,
            labelText: 'Username',
            keyboardType: TextInputType.emailAddress,
            controller: loginController.usernameController,
            onChanged: (_) => loginController.validateForm(),
            validator: (value) {
              return value!.isEmpty ? 'Please enter username' : null;
            },
          ),
          Obx(() {
            return AppTextFormField(
              textInputAction: TextInputAction.done,
              labelText: "Password",
              keyboardType: TextInputType.visiblePassword,
              controller: loginController.passwordController,
              obscureText: loginController.passwordObscure.value,
              onChanged: (_) => loginController.validateForm(),
              validator: (value) {
                return value!.isEmpty
                    ? "Please Enter password"
                    : AppRegex.passRegex.hasMatch(value)
                        ? null
                        : "Invalid Password";
              },
              suffixIcon: IconButton(
                icon: Icon(
                  loginController.passwordObscure.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: Colors.black,
                ),
                onPressed: () => loginController.togglePasswordVisibility(),
                style: IconButton.styleFrom(minimumSize: const Size.square(28)),
              ),
            );
          }),
          const SizedBox(height: 40),
          SubmitButton(
            onPressed: () {
              if (loginController.isFormValid.value) {
                loginController.login();
                userController.fetchAll();
              } else {
                null;
              }
            },
            title: 'Login',
          ),
        ],
      ),
    );
  }
}
