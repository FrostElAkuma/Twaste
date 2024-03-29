import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/order_controller.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:twaste/utils/styles.dart';

class DeliveryOptions extends StatelessWidget {
  final String value;
  final String title;
  final double amount;
  final bool isFree;
  const DeliveryOptions(
      {super.key,
      required this.value,
      required this.title,
      required this.amount,
      required this.isFree});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (orderController) {
      return Row(
        children: [
          Radio(
            value: value,
            onChanged: (String? value) =>
                orderController.setDeliveryType(value!),
            groupValue: orderController.orderType,
            activeColor: Theme.of(context).primaryColor,
          ),
          SizedBox(
            width: Dimensions.width10 / 2,
          ),
          Text(
            title,
            style: robotoRegular,
          ),
          SizedBox(
            width: Dimensions.width10 / 2,
          ),
          Text(
            '(${(value == 'take away' || isFree) ? 'Free' : '\$${amount / 10}'})',
            style: robotoMedium,
          )
        ],
      );
    });
  }
}
