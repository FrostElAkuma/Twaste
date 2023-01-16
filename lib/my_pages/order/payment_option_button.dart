import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:twaste/utils/styles.dart';

import '../../controllers/order_controller.dart';

class PaymentOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final int index;
  const PaymentOptionButton(
      {super.key,
      required this.icon,
      required this.title,
      required this.subTitle,
      required this.index});

  @override
  Widget build(BuildContext context) {
    //Get builder here so we can pass the index into our controller
    return GetBuilder<OrderController>(builder: (orderController) {
      bool _selected = orderController.paymentIndex == index;
      return InkWell(
        onTap: () => orderController.setPaymentIndex(index),
        child: Container(
          //Space between payment options
          padding: EdgeInsets.only(bottom: Dimensions.height10 / 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius20 / 4),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200]!,
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ]),
          //ListTile is super nice. it makes us chose and hilight the chosen list item
          child: ListTile(
            leading: Icon(
              icon,
              size: 40,
              color: _selected ? Colors.blue : Theme.of(context).disabledColor,
            ),
            title: Text(
              title,
              style: robotoMedium.copyWith(
                fontSize: Dimensions.font20,
              ),
            ),
            subtitle: Text(
              subTitle,
              //For overflowing text it will show as ...
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: robotoRegular.copyWith(
                color:
                    _selected ? Colors.blue : Theme.of(context).disabledColor,
                fontSize: Dimensions.font16,
              ),
            ),
            trailing: _selected
                ? Icon(
                    Icons.check_circle,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
        ),
      );
    });
  }
}
