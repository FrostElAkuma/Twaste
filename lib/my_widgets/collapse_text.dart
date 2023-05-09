import 'package:flutter/material.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/utils/dimensions.dart';

//This stateful class cuz the collapsing mechanism changes the view. Also we need setState class which only works in statful class
class CollapseText extends StatefulWidget {
  final String text;
  const CollapseText({super.key, required this.text});

  @override
  State<CollapseText> createState() => _CollapseTextState();
}

class _CollapseTextState extends State<CollapseText> {
  //late cuz we will initialize them later. but we have to initialize them before the app runs
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  //There are many ways to do this collapsable text, but we are doing the simplest one with counting the length of the text
  double textHeight = Dimensions.screenHeight / 5.63;

  @override
  void initState() {
    super.initState();
    if (widget.text.length > textHeight) {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf =
          widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    } else {
      firstHalf = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty
          ? SmallText(
              height: 1.8,
              color: const Color.fromARGB(66, 219, 56, 56),
              size: Dimensions.font16,
              text: firstHalf)
          : Column(
              children: [
                SmallText(
                    height: 1.8,
                    color: const Color.fromARGB(66, 209, 22, 22),
                    size: Dimensions.font16,
                    text: hiddenText
                        ? ("$firstHalf...")
                        : (firstHalf + secondHalf)),
                InkWell(
                  onTap: () {
                    //We use setState whenever we want to change the view of the app
                    setState(() {
                      //Everytime we click on the button we need to toggle hiddent text, If hidden text is false we will show the second half
                      hiddenText = !hiddenText;
                    });
                  },
                  child: Row(
                    children: [
                      SmallText(
                        text: hiddenText ? "Show more" : "Show less",
                        color: Colors.blue,
                      ),
                      Icon(
                        hiddenText
                            ? Icons.arrow_drop_down
                            : Icons.arrow_drop_up,
                        color: Colors.blue,
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
