import 'package:flutter/material.dart';
import 'package:twaste/my_widgets/myIcons.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/utils/dimensions.dart';

class AccountWidget extends StatelessWidget {
  MyIcons myIcons;
  LargeText largeText;
  AccountWidget({super.key, required this.myIcons, required this.largeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: Dimensions.width20,
          top: Dimensions.width10,
          bottom: Dimensions.width10),
      decoration:
          //This for shadow below each entry or below eah box
          BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 1,
          offset: const Offset(0, 5),
          color: Colors.grey.withOpacity(0.2),
        ),
      ]),
      child: Row(children: [
        myIcons,
        SizedBox(
          width: Dimensions.width20,
        ),
        largeText,
      ]),
    );
  }
}
