import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/dimensions.dart';
import 'distance_time.dart';
import 'my_text.dart';

class infoRating extends StatelessWidget {
  final String text;
  const infoRating({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
        //So everything is right aligned in the container
        crossAxisAlignment: CrossAxisAlignment.start,
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
                          size: 15,
                        )),
              ),
              //We use sized box to add space between the stars and text
              SizedBox(
                width: 10,
              ),
              SmallText(text: "4.5"),
              SizedBox(
                width: 10,
              ),
              SmallText(text: "123312"),
              SizedBox(
                width: 10,
              ),
              SmallText(text: "comments")
            ],
          ),
          SizedBox(height: Dimensions.height20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DistanceTime(
                  icon: Icons.circle_sharp,
                  text: "normal",
                  iconColor: Colors.orange),
              DistanceTime(
                  icon: Icons.location_on,
                  text: "1.7km",
                  iconColor: Colors.blue),
              DistanceTime(
                  icon: Icons.access_time_filled_rounded,
                  text: "32min",
                  iconColor: Colors.red),
            ],
          )
        ]);
  }
}
