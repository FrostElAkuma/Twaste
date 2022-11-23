import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:twaste/base/custom_loader.dart';
import 'package:twaste/base/show_custom_snackBar.dart';
import 'package:twaste/models/singUp_model.dart';
import 'package:twaste/my_widgets/input_field.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../controllers/auth_controller.dart';

//If we using Getx we can create all of our classes as stateless because Getx already has state ?
class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Controller for email so we can use the email input field. It is diffirent than the controllers that we coded our selves ?
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = [
      "t.png",
      "f.png",
      "g.png",
    ];
    //This method (function) is for validation
    void _registration(AuthController authController) {
      //We removed the line below because we already passed an authcntroller object into this metod from our scaffold s
      //var authController = Get.find<AuthController>();
      String name = nameController.text.trim();
      String phone = phoneController.text.trim();
      String email = emailController.text.trim();
      String password = passwordController.text.trim();

      if (name.isEmpty) {
        showCusotmSnackBar("Name can't be empty", title: "Name");
      } else if (phone.isEmpty) {
        showCusotmSnackBar("Phone can't be empty", title: "Phone");
      } else if (email.isEmpty) {
        showCusotmSnackBar("Email can't be empty", title: "Email");
      }
      //GetX has an already defined function for us to check if an email is real. It has more validation functions that we can use
      //I will comment it out for now because even when i am using a correct email address it is giving me an error
      /*else if (GetUtils.isEmail(email)) {
        showCusotmSnackBar("Invalid Email", title: "Invalid Email");
      }*/
      else if (password.isEmpty) {
        showCusotmSnackBar("Password can't be empty", title: "Password");
      } else if (password.length < 6) {
        showCusotmSnackBar("Password can't be less than six charachters",
            title: "Password");
      } else {
        SignUpBody signUpBody = SignUpBody(
            name: name, phone: phone, email: email, password: password);
        authController.registration(signUpBody).then((status) {
          //Reminder we definded isSuccess in our response model
          if (status.isSuccess) {
            print("Success registration");
            Get.offNamed(RouteHelper.getInitial());
          } else {
            showCusotmSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        //We used SingChildScrollView and physics so when the keybaord os on the screen there won't be any overflow errors
        //We used GetBuilder here so we can use the isLoading method
        body: GetBuilder<AuthController>(builder: (_authController) {
          return !_authController.isLoading
              ? SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(children: [
                    SizedBox(
                      height: Dimensions.screenHeight * 0.05,
                    ),
                    //Our Logo
                    Container(
                      height: Dimensions.screenHeight * 0.25,
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: Dimensions.radius20 * 4,
                          backgroundImage:
                              AssetImage("assets/images/Twasty.png"),
                        ),
                      ),
                    ),
                    //Input Fields
                    //Email Input Field
                    InputField(
                        textController: emailController,
                        hintText: "Email",
                        icon: Icons.email),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //Passwrod
                    InputField(
                      textController: passwordController,
                      hintText: "Password",
                      icon: Icons.password_sharp,
                      isObscure: true,
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //name
                    InputField(
                        textController: nameController,
                        hintText: "Name",
                        icon: Icons.person),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //phone
                    InputField(
                        textController: phoneController,
                        hintText: "Phone Number",
                        icon: Icons.phone),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //Sign Up button
                    GestureDetector(
                      onTap: () {
                        _registration(_authController);
                      },
                      child: Container(
                        width: Dimensions.screenWidth / 3,
                        height: Dimensions.screenHeight / 19,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius30),
                          color: Colors.blue,
                        ),
                        child: Center(
                          child: LargeText(
                            text: "sign up",
                            size: Dimensions.font20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.height10,
                    ),
                    //If you want a clickable container you can use a container OR the other way is to use RichText
                    //Our Have an account already text
                    RichText(
                      text: TextSpan(
                        //This is like gesture detector but for text
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Get.back(),
                        text: "Have an account already?",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: Dimensions.font20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.screenHeight * 0.02,
                    ),
                    //other sign up options
                    RichText(
                      text: TextSpan(
                        text: "Sign up using on of the following methods",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: Dimensions.font16,
                        ),
                      ),
                    ),
                    //Google, facebook, etc.
                    Wrap(
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: Dimensions.radius20,
                            backgroundImage: AssetImage(
                                "assets/images/" + signUpImages[index]),
                          ),
                        ),
                      ),
                    ),
                  ]),
                )
              : const CustomLoader();
        }));
  }
}
