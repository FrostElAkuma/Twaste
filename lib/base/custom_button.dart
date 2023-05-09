import 'package:flutter/material.dart';

import '../utils/dimensions.dart';

class CustomButton extends StatelessWidget {
  //CallBack ?
  final VoidCallback? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double? fontSize;
  final double radius;
  final IconData? icon;
  const CustomButton(
      {super.key,
      this.onPressed,
      required this.buttonText,
      this.transparent = false,
      this.margin,
      this.height,
      this.width,
      this.fontSize,
      this.radius = 5,
      this.icon});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButton = TextButton.styleFrom(
      backgroundColor: onPressed == null
          ? Theme.of(context).disabledColor
          : transparent
              ? Colors.transparent
              : Theme.of(context).primaryColor,
      minimumSize: Size(width != null ? width! : Dimensions.screenWidth,
          height != null ? height! : Dimensions.height30 + Dimensions.height20),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    return Center(
      child: SizedBox(
        //This another shorter way of saying width != null ? width! : Dimensions.screenWidth
        width: width ?? Dimensions.screenWidth,
        height: height ?? Dimensions.height30 + Dimensions.height20,
        child: TextButton(
          onPressed: onPressed,
          style: flatButton,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon != null
                  ? Padding(
                      padding: EdgeInsets.only(right: Dimensions.width10 / 2),
                      child: Icon(icon,
                          color: transparent
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).cardColor),
                    )
                  : const SizedBox(),
              Text(
                buttonText,
                style: TextStyle(
                    fontSize: fontSize ?? Dimensions.font16,
                    color: transparent
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).cardColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
