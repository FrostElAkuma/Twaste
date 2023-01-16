import 'package:flutter/material.dart';

import '../my_widgets/my_text.dart';
import '../utils/dimensions.dart';

class CommonTextButton extends StatelessWidget {
  final String text;
  const CommonTextButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: Dimensions.height20,
          bottom: Dimensions.height20,
          left: Dimensions.width20,
          right: Dimensions.width20),
      child: Center(
        child: LargeText(
          text: text,
          color: Colors.white,
        ),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 5),
            blurRadius: Dimensions.radius20 / 2,
            color: Colors.blue.withOpacity(0.3),
          ),
        ],
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        color: Colors.blue,
      ),
    );
  }
}
