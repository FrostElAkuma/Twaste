import 'package:flutter/material.dart';
import 'package:twaste/controllers/cart_controller.dart';
import 'package:twaste/my_pages/address/add_address_page.dart';
import 'package:twaste/my_pages/auth/sign_up_page.dart';
import 'package:twaste/my_pages/home/main_page.dart';
import 'package:get/get.dart';
import 'package:twaste/my_pages/restaurant/meal_page.dart';
import 'package:twaste/my_pages/splash/splash_page.dart';
import 'package:twaste/routes/route_helper.dart';
import 'controllers/meal_controller.dart';
import 'controllers/recommended_meals_controller.dart';
import 'my_pages/auth/sign_in_page.dart';
import 'my_pages/home/body_page.dart';
import 'my_pages/restaurant/restaurant_page.dart';
import 'helper/dependencies.dart' as dep;

Future<void> main() async {
  //This is to make sure that our dependancies are loaded
  WidgetsFlutterBinding.ensureInitialized();
  //This is how our dependancies are loaded before the app runs
  //before we run the App we need to load our dependancies
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.find<CartController>().getCartData();
    //Getting the data from our controller. VIP we need to do this for all our controllers so we can laod the data
    //This is not the most propper way to load the data and we will change it soon
    //We moved them to our splash page so they load there before we go to our main page
    //Get.find<MealController>().getMealList();
    //Get.find<RecommendedMealController>().getRecommendedMealList();
    //VIPPP When we call Get.find to load our data before we call GetMaterialApp usually they stay in memory but if we call them after they get deleted
    //That is why we use the 2 Get Builders. In getX that is one way to keep data in memory
    return GetBuilder<MealController>(builder: (_) {
      return GetBuilder<RecommendedMealController>(builder: (_) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          //We already defined initial route we do not need the line below
          //home: AddAddressPage(),
          initialRoute: RouteHelper.getSplashPage(),
          getPages: RouteHelper.routes,
        );
      });
    });
  }
}
