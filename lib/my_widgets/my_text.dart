import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:twaste/utils/dimensions.dart';

class LargeText extends StatelessWidget {
  // The question mark means that it is optional and not neccesary to be passed
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  LargeText({
    super.key,
    //Can only use hexa decimal color for constructor
    this.color = const Color(0xFF332d2b),
    required this.text,
    this.size = 0,
    this.overFlow = TextOverflow.ellipsis, // ellipses are the dots....
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: overFlow,
      style: TextStyle(
        //fontFamily: 'Roboto', need to add fonts later as well
        color: color,
        fontSize: size == 0 ? Dimensions.font20 : size,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class SmallText extends StatelessWidget {
  // The question mark means that it is optional and not neccesary to be passed
  Color? color;
  final String text;
  double size;
  double height;
  SmallText({
    super.key,
    //Can only use hexa decimal color for constructor
    this.color = const Color(0xFFccc7c5),
    required this.text,
    this.size = 12,
    this.height = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        //fontFamily: 'Roboto', need to add fonts later as well
        color: color,
        fontSize: size,
        height: height,
      ),
    );
  }
}
