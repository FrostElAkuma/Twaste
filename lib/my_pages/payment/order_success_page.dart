import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:twaste/base/custom_button.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../routes/route_helper.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderID;
  final int status;
  OrderSuccessPage({required this.orderID, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      Future.delayed(Duration(seconds: 1), () {
        //
      });
    }
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: Dimensions.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //We can also have an Icon instead of an image
            //Icon(status == 1 ? Icons.check_circle_outline: Icons.warning_amber_outlined, size: Dimensions.height20*5, color: Colors.blue,),
            Image.asset(
                status == 1
                    ? "assets/images/test2.png"
                    : "assets/images/cat.jpg",
                width: Dimensions.width20 * 5,
                height: Dimensions.height20 * 5),
            SizedBox(height: Dimensions.height30),
            Text(
              status == 1
                  ? "You placed the order successfully"
                  : "Your order failed",
              style: TextStyle(fontSize: Dimensions.font26),
            ),
            SizedBox(height: Dimensions.height20),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.height20,
                  vertical: Dimensions.height10),
              child: Text(
                status == 1 ? "Succesful order" : "Failed order",
                style: TextStyle(
                    fontSize: Dimensions.font20,
                    color: Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Padding(
              padding: EdgeInsets.all(Dimensions.height10),
              child: CustomButton(
                  buttonText: 'BAck to Home',
                  onPressed: () => Get.offAllNamed(RouteHelper.getInitial())),
            ),
          ],
        ),
      )),
    );
  }
}
