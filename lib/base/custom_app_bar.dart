import 'package:flutter/material.dart';
import 'package:twaste/my_widgets/my_text.dart';

//In order to use this widget I need to add implements PreferredSizedWidget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButtonExist;
  final Function? onBackPressed;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.backButtonExist = true,
      this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: LargeText(
        text: title,
        color: Colors.white,
      ),
      centerTitle: true,
      backgroundColor: Colors.blue,
      //To remove shadow under the appbar
      elevation: 0,
      //For our backButton
      leading: backButtonExist
          ? IconButton(
              onPressed: () => onBackPressed != null
                  ? onBackPressed!()
                  : Navigator.pushReplacementNamed(context, "/initial"),
              icon: Icon(Icons.arrow_back_ios))
          : SizedBox(),
    );
  }

  //PreferredSized Widget made me ovveride this
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(500, 50);
}
