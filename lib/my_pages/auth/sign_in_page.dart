
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/base/custom_loader.dart';
import 'package:twaste/my_pages/auth/sign_up_page.dart';
import 'package:twaste/my_widgets/input_field.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../base/show_custom_snackBar.dart';
import '../../controllers/auth_controller.dart';

//If we using Getx we can create all of our classes as stateless because Getx already has state ?
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Controller for email so we can use the email input field. It is diffirent than the controllers that we coded our selves ?
    //Using phone for signing in
    var phoneController = TextEditingController();
    //If i want to use the email to sign in i need to comment the line aboce and uncomment the line below
    //var emailController = TextEditingController();
    var passwordController = TextEditingController();

    void _login(AuthController authController) {
      //We removed the line below because we already passed an authcntroller object into this metod from our scaffold s
      //var authController = Get.find<AuthController>();
      String phone = phoneController.text.trim();
      String password = passwordController.text.trim();

      if (phone.isEmpty) {
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
        authController.login(phone, password).then((status) {
          //Reminder we definded isSuccess in our response model
          if (status.isSuccess) {
            //need to change this to home page instead of cartpage
            Get.toNamed(RouteHelper.getInitial());
          } else {
            showCusotmSnackBar(status.message);
          }
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        //We used SingChildScrollView and physics so when the keybaord os on the screen there won't be any overflow errors
        body: GetBuilder<AuthController>(builder: (authController) {
          return !authController.isLoading
              ? SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                    SizedBox(
                      height: Dimensions.screenHeight * 0.05,
                    ),
                    //Our Logo
                    SizedBox(
                      height: Dimensions.screenHeight * 0.25,
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: Dimensions.radius20 * 4,
                          backgroundImage:
                              const AssetImage("assets/images/Twasty.png"),
                        ),
                      ),
                    ),
                    //Welcome text
                    Container(
                      margin: EdgeInsets.only(left: Dimensions.width20),
                      //The crossAxisAlignment below will not work unless we have a width for our container
                      width: double.maxFinite,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello",
                              style: TextStyle(
                                fontSize: Dimensions.font20 * 3 +
                                    Dimensions.font20 / 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Sign into your account",
                              style: TextStyle(
                                fontSize: Dimensions.font20,
                                //fontWeight: FontWeight.bold,
                                color: Colors.grey[500],
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //Input Fields
                    //Email Input Field
                    InputField(
                        textController: phoneController,
                        hintText: "phone",
                        icon: Icons.phone),
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
                    //If you want a clockable container you can use a container OR the other way is to use RichText
                    //Our Sign into your acount text
                    Row(
                      children: [
                        //We used this expanded widget with an empty container so our text will be aligned to the right
                        Expanded(child: Container()),
                        RichText(
                          text: TextSpan(
                            text: "Sign into your account",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: Dimensions.font20,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Dimensions.width20,
                        )
                      ],
                    ),

                    SizedBox(
                      height: Dimensions.screenHeight * 0.05,
                    ),

                    //Sign In button
                    GestureDetector(
                      onTap: () {
                        _login(authController);
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
                            text: "Sign in",
                            size: Dimensions.font20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: Dimensions.screenHeight * 0.05,
                    ),

                    //Don't have an account text. We use RichText here so we can use 2 diffirent and put them in the same line
                    RichText(
                      text: TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: Dimensions.font20,
                          ),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => const SignUpPage(),
                                    transition: Transition.fade),
                              text: " Create",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: Dimensions.font20,
                              ),
                            ),
                          ]),
                    ),
                  ]),
                )
              : const CustomLoader();
        }));
  }
}
