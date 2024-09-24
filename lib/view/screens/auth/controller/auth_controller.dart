import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/core/app_routes.dart';
import 'package:task_manager/helper/sharedprefarence.dart';
import 'package:task_manager/service/api_url.dart';

class AuthenticationController extends GetxController {
  ///========================= Sign In =========================

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;

  ///========================= Sign Up =========================

  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> signupEmailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> signupPasswordController =
      TextEditingController().obs;

  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;

  Rx<TextEditingController> newPasswordController = TextEditingController().obs;

  Rx<TextEditingController> oldPasswordController = TextEditingController().obs;

  RxString activationCode = "".obs;
  //================================================sign in function=========here

  signIn() async {
    Map<String, dynamic> body = {
      "email": emailController.value.text,
      "password": passwordController.value.text,
    };

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    try {
      var response = await http.post(
        Uri.parse(ApiUrl.baseUrl + ApiUrl.loginUrl),
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> decode = jsonDecode(response.body);
        String? token = decode["data"]["token"];
        print("your token is here $token");
        SharePrefsHelper.setString("token", token);

        if (decode["status"] == "Success") {
          Get.snackbar(
            "Success",
            decode["message"],
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.toNamed(AppRoute.homeScreen);
        } else {
          Get.snackbar(
            "Unsuccessful",
            "Login User is not valid",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Unsuccessful",
          "Response unsuccessful with status code: ${response.statusCode}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Server Error",
        "An error occurred: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
