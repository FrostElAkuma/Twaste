import 'package:get/get.dart';
import 'package:twaste/models/order_model.dart';
import 'package:twaste/my_pages/address/add_address_page.dart';
import 'package:twaste/my_pages/auth/sign_in_page.dart';
import 'package:twaste/my_pages/home/main_page.dart';
import 'package:twaste/my_pages/payment/payment_page.dart';
import 'package:twaste/my_pages/restaurant/meal_page.dart';
import 'package:twaste/my_pages/restaurant/restaurant_page.dart';
import 'package:twaste/my_pages/splash/splash_page.dart';

import '../my_pages/address/pick_address_map.dart';
import '../my_pages/cart/cart_page.dart';
import '../my_pages/home/home_page.dart';
import '../my_pages/payment/order_success_page.dart';

class RouteHelper {
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String restaurant = "/restaurant";
  static const String recommendedFood = "/recommended-food";
  static const String cartPage = "/cart-page";
  static const String signIn = "/sign-in";

  static const String addAddress = "/add-address";
  static const String pickAddressMap = "/pick-address";

  static const String payment = '/payment';
  static const String orderSuccess = '/order-succesful';

  //We use this so we can pass parameters and have different routes
  //When we call this line of code below it will go to the corresponding route in the list routes
  static String getSplashPage() => '$splashPage';
  static String getInitial() => '$initial';
  static String getRestaurant(int pageId, String page) =>
      '$restaurant?pageId=$pageId&page=$page';
  static String getRecommendedFood(int pageId, String page) =>
      '$recommendedFood?pageId=$pageId&page=$page';
  static String getCartPage() => '$cartPage';
  static String getSignInPage() => '$signIn';

  static String getAddressPage() => '$addAddress';
  static String getPickAddressPage() => '$pickAddressMap';

  static String getPaymentPage(String id, int userId) =>
      '$payment?id=$id&userId=$userId';
  static String getOrderSuccessPage(String orderID, String status) =>
      '$orderSuccess?id=$orderID&status=$status';

  //GetPge is the data type
  static List<GetPage> routes = [
    GetPage(
      name: pickAddressMap,
      page: () {
        //We are passing a widget or a screen here, which is a bit diffirent than what we used to do passing parameters
        PickAddressMap _pickAddress = Get.arguments;
        return _pickAddress;
      },
    ),
    GetPage(name: splashPage, page: () => SplashScreen()),
    GetPage(
        name: initial,
        page: () {
          return HomePage();
        },
        transition: Transition.fade),
    GetPage(
      name: signIn,
      page: () {
        return SignInPage();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: restaurant,
      page: () {
        var pageId = Get.parameters['pageId'];
        var page = Get.parameters['page'];
        //We needed to cast it to int cuz the above line of code may get us the id as a string
        return RestaurantDetails(pageId: int.parse(pageId!), page: page!);
      },
      //Nice transition when going to a page
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: recommendedFood,
      page: () {
        var pageId = Get.parameters['pageId'];
        var page = Get.parameters['page'];
        return Meal(pageId: int.parse(pageId!), page: page!);
      },
      //Nice transition when going to a page
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cartPage,
      page: () {
        return CartPage();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addAddress,
      page: () {
        return AddAddressPage();
      },
    ),
    GetPage(
      name: payment,
      page: () => PaymentPage(
        orderModel: OrderModel(
          id: int.parse(Get.parameters['id']!),
          userId: int.parse(Get.parameters["userId"]!),
        ),
      ),
    ),
    GetPage(
        name: orderSuccess,
        page: () => OrderSuccessPage(
              orderID: Get.parameters['id']!,
              status: Get.parameters["status"].toString().contains("success")
                  ? 1
                  : 0,
            ))
  ];
}
