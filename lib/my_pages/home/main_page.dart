import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:twaste/my_pages/home/body_page.dart';
import 'package:twaste/utils/colors.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:twaste/my_widgets/my_text.dart';

import '../../controllers/meal_controller.dart';
import '../../controllers/recommended_meals_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MainPage> {
  Future<void> _loadRescources() async {
    await Get.find<MealController>().getMealList();
    await Get.find<RecommendedMealController>().getRecommendedMealList();
  }

  @override
  Widget build(BuildContext context) {
    //print("current height is " + MediaQuery.of(context).size.height.toString());
    //print("current width is " + MediaQuery.of(context).size.width.toString());

    return RefreshIndicator(
        child: Column(
          children: [
            //header
            Container(
              child: Container(
                margin: EdgeInsets.only(
                    top: Dimensions.height45, bottom: Dimensions.height15),
                padding: EdgeInsets.only(
                    left: Dimensions.width20, right: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        //Using these custom text widgets will save us a lot of time
                        LargeText(text: "myCountry"),
                        Row(
                          children: [
                            SmallText(
                              text: "city",
                              color: Colors.black54,
                            ),
                            Icon(Icons.arrow_drop_down_rounded),
                          ],
                        )
                      ],
                    ),
                    Center(
                      child: Container(
                        width: Dimensions.width45,
                        height: Dimensions.height45,
                        //default size for icon is 24
                        child: Icon(Icons.search,
                            color: Colors.white, size: Dimensions.iconSize24),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          color: MyTheme.mainColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //showing the body
            //We had some page scrolling issues so we had to use expanded and SingleChildScrollView
            Expanded(
                child: SingleChildScrollView(
              child: BodyPage(),
            )),
          ],
        ),
        onRefresh: _loadRescources);
  }
}
