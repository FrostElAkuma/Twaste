import 'package:get/get.dart';

class Dimensions {
  static double screenHeight = Get.context!.height;
  static double screenWidth = Get.context!.width;

  //731.4285714285714 / 220 = 3.325 // we got the 731.4 from the device width i was working on. so we are using the 3.235 as a scaling factors. we got 220 because that is the original size that we want
  //dynamic values for padding margin etc.
  static double pageVeiw = screenHeight / 2.28571;
  static double pageVeiwContainer = screenHeight / 3.325;
  static double pageVeiwTextContainer = screenHeight / 6.095;

//height
  static double height10 = screenHeight / 73.143;
  static double height15 = screenHeight / 48.76;
  static double height20 = screenHeight / 36.5;
  static double height30 = screenHeight / 24.38;
  static double height45 = screenHeight / 16.25;

  //font
  static double font16 = screenHeight / 45.7;
  static double font20 = screenHeight / 36.5;
  static double font26 = screenHeight / 28.1;

  //radius
  static double radius15 = screenHeight / 48.762;
  static double radius20 = screenHeight / 36.5;
  static double radius30 = screenHeight / 24.381;

  //width
  static double width10 = screenHeight / 73.143;
  static double width15 = screenHeight / 48.76;
  static double width20 = screenHeight / 36.5;
  static double width30 = screenHeight / 24.38;
  static double width45 = screenHeight / 16.25;

  //Icon size
  static double iconSize24 = screenHeight / 30.47;
  static double iconSize16 = screenHeight / 45.7;

  //For our main restaurant cards
  static double restaurantListImg = screenWidth / 3.43;
  static double restaurantListInfo = screenWidth / 4.114;

  //For our Restaurant page
  static double restaurantCoverImg = screenHeight / 2;

  //height for add to cart thing. I dived the screen height by 120 for refrence
  static double bottomHeightBar = screenHeight / 6.1;

  //splash screen
  static double splashImage = screenHeight / 2.925;
}
