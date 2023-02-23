import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twaste/controllers/add_meal_controller.dart';
import 'package:twaste/controllers/auth_controller.dart';
import 'package:twaste/controllers/cart_controller.dart';
import 'package:twaste/controllers/location_controller.dart';
import 'package:twaste/controllers/meal_controller.dart';
import 'package:twaste/controllers/order_controller.dart';
import 'package:twaste/data/api/api_client.dart';
import 'package:twaste/data/repository/add_meal_repo.dart';
import 'package:twaste/data/repository/location_repo.dart';
import 'package:twaste/data/repository/meals_repo.dart';
import 'package:twaste/data/repository/restaurant_repo.dart';
import 'package:twaste/utils/my_constants.dart';

import '../controllers/recommended_meals_controller.dart';
import '../controllers/restaurant_controller.dart';
import '../controllers/user_controller.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/cart_reop.dart';
import '../data/repository/order_repo.dart';
import '../data/repository/recommended_meals_repo.dart';
import '../data/repository/user_repo.dart';

//Cus we using future we need to add async ? (this init is new for me)
//This init will be called form our name file. You can refrence the picture in the video to see the app architecture
//VIP every controller needs its own repo and we need to load them in the dependancies
Future<void> init() async {
  //initializing local storage. It needs to be the first line ?
  final sharedPreferences = await SharedPreferences.getInstance();
  //So we can use it in our controllers
  Get.lazyPut(() => sharedPreferences);
  //So we load our dependencies here
  //Usually we load our ApiClient first
  Get.lazyPut(() => ApiClient(
      appBaseUrl: MyConstants.BASE_URL, sharedPreferences: Get.find()));
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));

  //Generally next are repositories
  //Get.find = Getx wil find the value for me ig
  Get.lazyPut(() => RestaurantRepo(apiClient: Get.find()));
  Get.lazyPut(() => MealRepo(apiClient: Get.find()));
  Get.lazyPut(() => RecommendedMealRepo(apiClient: Get.find()));
  //We pass our sharedPreferences here
  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(
      () => LocationRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => OrderRepo(apiClient: Get.find()));
  Get.lazyPut(() => AddMealRepo(apiClient: Get.find()));

  //controllers
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => RestaurantController(restaurantRepo: Get.find()));
  Get.lazyPut(() => MealController(mealRepo: Get.find()));
  Get.lazyPut(() => RecommendedMealController(recommendedMealRepo: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find()));
  Get.lazyPut(() => LocationController(locationRepo: Get.find()));
  Get.lazyPut(() => OrderController(orderRepo: Get.find()));
  Get.lazyPut(() => AddMealController(addMealRepo: Get.find()));
}
