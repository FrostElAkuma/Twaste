import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/my_widgets/my_text.dart';

//Usually when we rap our parameters around curly braces it means that they are optional ?? (When I try to pass in the optional arguments it tells me too many arguments??)
void showCusotmSnackBar(String message,
    {bool isError = true, String title = "Error"}) {
  Get.snackbar(
    title,
    message,
    titleText: LargeText(
      text: title,
      color: Colors.white,
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError ? Colors.redAccent : Colors.green,
  );
}
