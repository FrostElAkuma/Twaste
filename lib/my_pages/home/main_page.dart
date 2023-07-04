import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/restaurant_controller.dart';
import 'package:twaste/my_pages/home/body_page.dart';
import 'package:twaste/utils/colors.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:twaste/my_widgets/my_text.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/meal_controller.dart';
import '../../controllers/recommended_meals_controller.dart';
import '../../controllers/user_controller.dart';
import '../../routes/route_helper.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    _loadRescources();
  }

  //Is this even working ? Not sure of they are getting called. I commented them out and apparently they are not dong any thing. need to call the loadrecources method from the initstate
  Future<void> _loadRescources() async {
    //await Get.find<MealController>().getMealList();
    //await Get.find<RecommendedMealController>().getRecommendedMealList(3);
    //await Get.find<RestaurantController>().getRestaurantList();
    bool userLoggedIn = await Get.find<AuthController>().userLoggedIn();
    print("I am here 2");
    print(userLoggedIn);
    if (userLoggedIn) {
      await Get.find<UserController>().getUserInfo();
      //I had a bug where the address was empty every time the user logs in. Issue was that I only called getAddressList when the user pressed the save address button
      await Get.find<LocationController>().getAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {
    //print("current height is " + MediaQuery.of(context).size.height.toString());
    //print("current width is " + MediaQuery.of(context).size.width.toString());

    return RefreshIndicator(
        onRefresh: _loadRescources,
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
                    GestureDetector(
                      onTap: () {
                        Get.offNamed(RouteHelper.getAddressPage());
                      },
                      child: Column(
                        children: [
                          //Using getbuilder here so When the address list is finally loaded it auto updates the view. Else if we don't use getbuilder the view will be stuck on the initial value
                          GetBuilder<LocationController>(builder: (loc) {
                            return !loc.addressList.isNotEmpty
                                ? LargeText(text: "Unkown")
                                : LargeText(
                                    text: Get.find<LocationController>()
                                        .getUserAddress()
                                        .city);
                          }),
                          //Using these custom text widgets will save us a lot of time
                          //LargeText(text: city1),
                          Row(
                            children: [
                              GetBuilder<LocationController>(builder: (loc) {
                                return !loc.addressList.isNotEmpty
                                    ? SmallText(text: "Unkown")
                                    : SmallText(
                                        text: Get.find<LocationController>()
                                            .getUserAddress()
                                            .neighbour);
                              }),
                              const Icon(Icons.arrow_drop_down_rounded),
                            ],
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        width: Dimensions.width45,
                        height: Dimensions.height45,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          color: MyTheme.mainColor,
                        ),
                        //default size for icon is 24
                        child: Icon(Icons.search,
                            color: Colors.white, size: Dimensions.iconSize24),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //showing the body
            //We had some page scrolling issues so we had to use expanded and SingleChildScrollView
            const Expanded(
                child: SingleChildScrollView(
              child: BodyPage(),
            )),
          ],
        ));
  }
}
