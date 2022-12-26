import 'package:get/get.dart';
import 'package:twaste/base/show_custom_snackBar.dart';
import 'package:twaste/routes/route_helper.dart';

//Reminder Response is from Getx Package
class ApiChecker {
  static void checkApi(Response response) {
    //401 forbiden means that you do not have authorization which means that you did not log in
    if (response.statusCode == 401) {
      Get.offNamed(RouteHelper.getSignInPage());
    } else {
      print("I am here at line 12 api_checker");
      showCusotmSnackBar(response.statusText!);
    }
  }
}
