import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import 'distance_time.dart';
import 'my_text.dart';

class infoRating extends StatelessWidget {
  final String text;
  final bool start;
  const infoRating({super.key, required this.text, this.start = true});

  @override
  Widget build(BuildContext context) {
    return Column(
        //So everything is right aligned in the container
        crossAxisAlignment:
            start ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          LargeText(
            text: text,
            size: Dimensions.font26,
          ),
          SizedBox(height: Dimensions.height10),
          Row(
            children: [
              //We use wrap so the stars can be aligned horizontally
              Wrap(
                children: List.generate(
                    5,
                    (index) => Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: Dimensions.font12,
                        )),
              ),
              //We use sized box to add space between the stars and text
              SizedBox(
                width: Dimensions.width10,
              ),
              SmallText(
                text: "4.5",
                size: Dimensions.font12,
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              SmallText(
                text: "123312",
                size: Dimensions.font12,
              ),
              SizedBox(
                width: Dimensions.width10,
              ),
              SmallText(
                text: "comments",
                size: Dimensions.font12,
              )
            ],
          ),
          SizedBox(height: Dimensions.height20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DistanceTime(
                icon: Icons.percent,
                text: "50 off",
                iconColor: Colors.orange,
              ),
              DistanceTime(
                  icon: Icons.location_on,
                  text: "1.7km",
                  iconColor: Colors.blue),
              DistanceTime(
                  icon: Icons.access_time_filled_rounded,
                  text: "7pm-9pm",
                  iconColor: Colors.red),
            ],
          )
        ]);
  }
}
