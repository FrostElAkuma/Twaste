import 'package:flutter/cupertino.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:twaste/my_widgets/my_text.dart';

class DistanceTime extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  const DistanceTime(
      {super.key,
      required this.icon,
      required this.text,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: iconColor,
          size: Dimensions.iconSize24,
        ),
        SizedBox(width: Dimensions.width10 / 2),
        SmallText(
          text: text,
        )
      ],
    );
  }
}
