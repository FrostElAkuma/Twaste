import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/base/custom_app_bar.dart';
import 'package:twaste/base/custom_loader.dart';
import 'package:twaste/controllers/auth_controller.dart';
import 'package:twaste/controllers/cart_controller.dart';
import 'package:twaste/controllers/location_controller.dart';
import 'package:twaste/controllers/user_controller.dart';
import 'package:twaste/my_widgets/account_widget.dart';
import 'package:twaste/my_widgets/myIcons.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/dimensions.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    //print("I am here 2");
    print(userLoggedIn);
    if (userLoggedIn) {
      Get.find<UserController>().getUserInfo();
      //I had a bug where the address was empty every time the user logs in. Issue was that I only called getAddressList when the user pressed the save address button
      Get.find<LocationController>().getAddressList();
    }

    //We use Scaffold if we want an app bar
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Profile",
      ),
      //Do not forget we use get builder when we want to use data froma controller
      body: GetBuilder<UserController>(builder: (userController) {
        return userLoggedIn
            ? (userController.isLoading
                ? const CustomLoader()
                : /*Container(
                        child: Center(
                          child: Text("You are logged in"),
                        ),
                      )*/
                Container(
                    //This centeres our column?
                    width: double.maxFinite,
                    margin: EdgeInsets.only(top: Dimensions.height20),
                    child: Column(
                      children: [
                        //profile icon
                        MyIcons(
                          icon: Icons.person,
                          backgroundColor: Colors.blue,
                          iconColor: Colors.white,
                          iconSize: Dimensions.height15 * 5,
                          size: Dimensions.height15 * 10,
                        ),
                        SizedBox(
                          height: Dimensions.height30,
                        ),
                        //We need to wrap the SingleChildScroll inside an Expanded widget in order for it to work
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                //name
                                AccountWidget(
                                    myIcons: MyIcons(
                                      icon: Icons.person,
                                      backgroundColor: Colors.blue,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    largeText: LargeText(
                                      text: userController.userModel!.name,
                                    )),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                //number
                                AccountWidget(
                                    myIcons: MyIcons(
                                      icon: Icons.phone,
                                      backgroundColor: Colors.yellow,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    largeText: LargeText(
                                      text: userController.userModel!.phone,
                                    )),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                //email
                                AccountWidget(
                                    myIcons: MyIcons(
                                      icon: Icons.email,
                                      backgroundColor: Colors.yellow,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    largeText: LargeText(
                                      text: userController.userModel!.email,
                                    )),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                //address
                                GetBuilder<LocationController>(
                                    builder: (locationController) {
                                  if (locationController.loading) {
                                    return const CustomLoader();
                                  }
                                  if (userLoggedIn &&
                                      locationController.addressList.isEmpty) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.offNamed(
                                            RouteHelper.getAddressPage());
                                      },
                                      child: AccountWidget(
                                        myIcons: MyIcons(
                                          icon: Icons.location_on,
                                          backgroundColor: Colors.yellow,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height10 * 5 / 2,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        largeText: LargeText(
                                            text: "Fill your Address here"),
                                      ),
                                    );
                                  } else {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.offNamed(
                                            RouteHelper.getAddressPage());
                                      },
                                      child: AccountWidget(
                                        myIcons: MyIcons(
                                          icon: Icons.location_on,
                                          backgroundColor: Colors.yellow,
                                          iconColor: Colors.white,
                                          iconSize: Dimensions.height10 * 5 / 2,
                                          size: Dimensions.height10 * 5,
                                        ),
                                        largeText:
                                            LargeText(text: "Your address"),
                                      ),
                                    );
                                  }
                                }),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                //messaage
                                AccountWidget(
                                    myIcons: MyIcons(
                                      icon: Icons.message_outlined,
                                      backgroundColor: Colors.redAccent,
                                      iconColor: Colors.white,
                                      iconSize: Dimensions.height10 * 5 / 2,
                                      size: Dimensions.height10 * 5,
                                    ),
                                    largeText: LargeText(
                                      text: "Messages",
                                    )),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                                //logout
                                GestureDetector(
                                  onTap: () {
                                    //Only if user is logged in already we logout and clear data
                                    if (Get.find<AuthController>()
                                        .userLoggedIn()) {
                                      Get.find<AuthController>()
                                          .clearSharedData();
                                      Get.find<CartController>().clear();
                                      Get.find<CartController>()
                                          .clearCartHistory();
                                      Get.find<LocationController>()
                                          .clearAddressList();
                                      Get.offNamed(RouteHelper.getSignInPage());
                                    } else {
                                      print("you logedout");
                                    }
                                  },
                                  child: AccountWidget(
                                      myIcons: MyIcons(
                                        icon: Icons.logout,
                                        backgroundColor: Colors.redAccent,
                                        iconColor: Colors.white,
                                        iconSize: Dimensions.height10 * 5 / 2,
                                        size: Dimensions.height10 * 5,
                                      ),
                                      largeText: LargeText(
                                        text: "Logout",
                                      )),
                                ),
                                SizedBox(
                                  height: Dimensions.height20,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            : Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: Dimensions.height20 * 8,
                        margin: EdgeInsets.only(
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/cat.jpg"))),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteHelper.getSignInPage());
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: Dimensions.height20 * 5,
                          margin: EdgeInsets.only(
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                          ),
                          child: Center(
                            child: LargeText(
                              text: "Sign in",
                              color: Colors.white,
                              size: Dimensions.font26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
