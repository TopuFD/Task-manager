import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:task_manager/helper/sharedprefarence.dart';
import 'package:task_manager/model/task_model.dart';
import 'package:task_manager/service/api_url.dart';

class HomeController extends GetxController {
  ///========================= textfield controller =========================

  Rx<TextEditingController> titleController = TextEditingController().obs;
  Rx<TextEditingController> desceController = TextEditingController().obs;
  Rx<TaskModel> taskModel = TaskModel().obs;

getTask() async {
    var getTaskUrl = Uri.parse(ApiUrl.baseUrl + ApiUrl.getTask);
    String? token = await SharePrefsHelper.getString('token');
    try {
      var response = await http.get(
        getTaskUrl,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var decode = jsonDecode(response.body);
      if (response.statusCode == 200) {
        taskModel.value = TaskModel.fromJson(decode);
        print("data gated");
      } else {
        debugPrint("Status code: ${response.statusCode}");
        debugPrint("Failed to load tasks");
        return [];
      }
    } catch (e) {
      debugPrint("Error message: ${e.toString()}");
      return [];
    }
  }

  // ==========================================add task here=======================>

  postTask() async {
    var url = Uri.parse(ApiUrl.baseUrl + ApiUrl.postTask);
    String? token = await SharePrefsHelper.getString('token');

    var body = json.encode({
      'title': titleController.value.text.isNotEmpty
          ? titleController.value.text
          : 'Default Title',
      'description': desceController.value.text.isNotEmpty
          ? desceController.value.text
          : 'Default Description',
    });

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      getTask();
      Get.snackbar("Success", "Task created successful");
      titleController.value.clear();
      desceController.value.clear();
      navigator?.pop();
    } else {
      Get.snackbar("UnSuccess", "Task created is not successful");
    }
  }
  @override
  void onInit() {
    getTask();
    super.onInit();
  }
}
