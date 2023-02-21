import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twaste/controllers/add_meal_controller.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../base/custom_app_bar.dart';
import '../../utils/my_constants.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({super.key});

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  //Save the picked image here
  File? _image;
  //The file picked from the phone's gallery
  PickedFile? _pickedFile;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Add New Item",
      ),
      body: GetBuilder<AddMealController>(builder: (addMealController) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(Dimensions.height30),
            child: Column(
              children: [
                Center(
                  child: GestureDetector(
                    child: Text('Select An Image'),
                    onTap: () => addMealController.pickImage(),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height30,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: Dimensions.height20 * 10,
                  color: Colors.grey[300],
                  child: addMealController.pickedFile != null
                      ? Image.file(
                          File(addMealController.pickedFile!.path),
                          width: Dimensions.width10 * 10,
                          height: Dimensions.height10 * 10,
                          fit: BoxFit.cover,
                        )
                      : const Text('Please select an image'),
                ),
                SizedBox(
                  height: Dimensions.height30,
                ),
                //This server upload section
                Center(
                  child: GestureDetector(
                    child: Text('Server upload'),
                    onTap: () => addMealController.upload(),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height30,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: Dimensions.height20 * 10,
                  color: Colors.grey[300],
                  child: addMealController.imagePath != null
                      ? Image.network(
                          MyConstants.BASE_URL + addMealController.imagePath!,
                          width: Dimensions.width10 * 10,
                          height: Dimensions.height10 * 10,
                          fit: BoxFit.cover,
                        )
                      : const Text('Please select an image'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
