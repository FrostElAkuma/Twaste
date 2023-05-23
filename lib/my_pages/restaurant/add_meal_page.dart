// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twaste/controllers/add_meal_controller.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../base/custom_app_bar.dart';
import '../../base/show_custom_snackBar.dart';
import '../../my_widgets/input_field.dart';
import '../../my_widgets/my_text.dart';
import '../../routes/route_helper.dart';

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
    var nameController = TextEditingController();
    var descriptionController = TextEditingController();
    var priceController = TextEditingController();
    var newPriceController = TextEditingController();

    Future<void> _validation(AddMealController mealController) async {
      //We removed the line below because we already passed an authcntroller object into this metod from our scaffold s
      //var authController = Get.find<AuthController>();
      String name = nameController.text.trim();
      String description = nameController.text.trim();
      String price = priceController.text.trim();
      int price2 = int.parse(price);
      String newPrice = priceController.text.trim();
      int newPrice2 = int.parse(newPrice);
      //Getting the Image path
      //bool imgGood = await mealController.upload();
      //String img = await mealController.imagePath!;

      if (name.isEmpty) {
        showCusotmSnackBar("Name can't be empty", title: "Name");
      } else if (description.isEmpty) {
        showCusotmSnackBar("Description can't be empty", title: "Description");
      } else if (price.isEmpty) {
        showCusotmSnackBar("Price can't be empty", title: "Price");
      } else if (newPrice.isEmpty) {
        showCusotmSnackBar("New price can't be empty", title: "New price");
      } /*else if (imgGood) {
        showCusotmSnackBar("Failed to get image path", title: "Img");
      }*/
      else {
        /*ProductModel productModel = ProductModel(
          name: name,
          price: price2,
          img: mealController.imagePath,
        );*/
        mealController
            .addMeal(name, description, price2, newPrice2)
            .then((status) {
          //Reminder we definded isSuccess in our response model
          if (status.isSuccess) {
            print("Success upload");
            //Get.offNamed(RouteHelper.getInitial());
            //At first it the re route was nto working but after looking a bit I need to add the prevent duplicates: false for it to work :D
            Get.toNamed(RouteHelper.getInitial(), preventDuplicates: false);
            showCusotmSnackBar(status.message,
                isError: false, title: 'refresh');
          } else {
            showCusotmSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Add New Item",
      ),
      body: GetBuilder<AddMealController>(builder: (addMealController) {
        return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(Dimensions.height30),
              child: Column(
                children: [
                  //Name
                  InputField(
                      textController: nameController,
                      hintText: "Name of Meal",
                      icon: Icons.title),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  //Description
                  InputField(
                      textController: descriptionController,
                      hintText: "Description of Meal",
                      icon: Icons.text_fields),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  //price
                  InputField(
                      textController: priceController,
                      hintText: "Old price of Meal",
                      icon: Icons.money),
                  SizedBox(
                    height: Dimensions.height20,
                  ),
                  //new price
                  InputField(
                      textController: newPriceController,
                      hintText: "New price of Meal",
                      icon: Icons.attach_money),
                  SizedBox(
                    height: Dimensions.height20,
                  ),

                  GestureDetector(
                    onTap: () {
                      addMealController.pickImage();
                    },
                    child: Container(
                      width: Dimensions.screenWidth / 2,
                      height: Dimensions.screenHeight / 19,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: LargeText(
                          text: "Select an Image",
                          size: Dimensions.font20,
                          color: Colors.white,
                        ),
                      ),
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
                  GestureDetector(
                    onTap: () {
                      _validation(addMealController);
                    },
                    child: Container(
                      width: Dimensions.screenWidth / 3,
                      height: Dimensions.screenHeight / 19,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius30),
                        color: Colors.green,
                      ),
                      child: Center(
                        child: LargeText(
                          text: "add meal",
                          size: Dimensions.font20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  //This server upload section
                  /*Center(
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
                  ),*/
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
