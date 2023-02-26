import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/auth_controller.dart';
import 'package:twaste/controllers/restaurant_controller.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../controllers/meal_controller.dart';
import '../../controllers/recommended_meals_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

//Need to use the with TickerProviderStateMixin for the animatiopn to work
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  //these 2 lines will control pur animation
  late Animation<double> animation;
  //We need an animation controlelr
  late AnimationController controller;

  //To load our data and recoursces from the internet wgile the user is in loading screen
  Future<void> _loadRescources() async {
    await Get.find<MealController>().getMealList();
    await Get.find<RecommendedMealController>().getRecommendedMealList(2);
    await Get.find<RestaurantController>().getRestaurantList();
  }

  @override
  void initState() {
    super.initState();
    //Geting device token for our notifactions
    Get.find<AuthController>().updateToken();
    _loadRescources();
    //..forward to start the animation
    controller =
        new AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..forward();
    animation = new CurvedAnimation(parent: controller, curve: Curves.linear);
    //So after 3 seconds go to the main page. But we need a route for our splash screen
    Timer(Duration(seconds: 3), () => Get.offNamed(RouteHelper.getInitial()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body:
          //This background image
          Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.23),
              BlendMode.modulate,
            ),
            fit: BoxFit.cover,
          ),
        ),
        //This logo and text
        child: Column(
            //styling purposes
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: animation,
                child: Center(
                  child: Image.asset(
                    "assets/images/Twasty.png",
                    width: Dimensions.splashImage,
                  ),
                ),
              ),
              //Just need this to be poppins then it would be the same as in figma
              Center(
                  child: LargeText(
                text: "Same Taste ",
                size: 48,
                color: Colors.white,
              )),
              Center(
                child: LargeText(
                  text: "Less Waste",
                  size: 48,
                  color: Colors.white,
                ),
              )
            ]),
      ),

      /*Column(
          //styling purposes
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/Twasty.png",
                width: 250,
              ),
            )
          ])*/
    );
  }
}
