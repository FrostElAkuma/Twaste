import 'package:flutter/cupertino.dart';

class MyIcons extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;

  const MyIcons({
    super.key,
    required this.icon,
    //colors must be const as a default value, so we can;t import any thing from our app colors
    this.backgroundColor = const Color(0xFFfcf4e4),
    this.iconColor = const Color(0xFF756d54),
    this.size = 40,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        //size/2 to make it a circle
        borderRadius: BorderRadius.circular(size / 2),
        color: backgroundColor,
      ),
      //for our icon
      child: Icon(
        icon,
        color: iconColor,
        size: iconSize,
      ),
    );
  }
}
