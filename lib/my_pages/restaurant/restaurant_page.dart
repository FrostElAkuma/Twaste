import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:twaste/controllers/meal_controller.dart';
import 'package:twaste/controllers/restaurant_controller.dart';
import 'package:twaste/my_pages/cart/cart_page.dart';
import 'package:twaste/my_pages/home/main_page.dart';
import 'package:twaste/my_widgets/myIcons.dart';
import 'package:twaste/my_widgets/collapse_text.dart';
import 'package:twaste/my_widgets/info_and_rating.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:twaste/utils/my_constants.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/recommended_meals_controller.dart';
import '../../my_widgets/distance_time.dart';
import '../../my_widgets/my_text.dart';
import '../../routes/route_helper.dart';

class RestaurantDetails extends StatelessWidget {
  final int pageId;
  final String page;
  const RestaurantDetails(
      {super.key, required this.pageId, required this.page});

  @override
  Widget build(BuildContext context) {
    Get.find<RecommendedMealController>().getRecommendedMealList(pageId);
    var meal =
        Get.find<RecommendedMealController>().recommendedMealList[pageId];
    var restaurant =
        Get.find<RestaurantController>().restaurantList[pageId - 2];
    //To initialize the number of products added to 0. Whenever a pager is built this function is called. In our whole app we only have 1 cart // we also passing the product / meal
    Get.find<MealController>().initProduct(meal, Get.find<CartController>());
    //print("page id is " + pageId.toString());
    //print("meal name is " + meal.name.toString());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            //Co
            Container(
              height: Dimensions.height20 * 100,
            ),
            //Cover image
            Positioned(
                //need to understand this positioned method more
                left: 0,
                right: 0,
                child: Container(
                  //maxFinite takes all available width
                  width: double.maxFinite,
                  height: Dimensions.restaurantCoverImg,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          //Again fit so it fills the whole screen
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            MyConstants.BASE_URL +
                                MyConstants.UPLOAD_URL +
                                restaurant.img!,
                          ))),
                )),
            //Back and cart icons
            Positioned(
                //I added this comment so the auto formatter does its job
                top: Dimensions.height45,
                left: Dimensions.width20,
                right: Dimensions.width20,
                child: Row(
                  //We use this so here will be space between the arrow and cart icons
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (page == "cartpage") {
                            Get.toNamed(RouteHelper.getCartPage());
                          } else {
                            Get.toNamed(RouteHelper.getInitial());
                          }
                        },
                        child: MyIcons(icon: Icons.arrow_back_ios)),
                    //Showing the number of items in cart
                    GetBuilder<MealController>(builder: (controller) {
                      //we used stack cuz not all items might show up,so we keep it dynamic
                      return GestureDetector(
                        onTap: () {
                          //if (controller.totalItems >= 1) {
                          Get.toNamed(RouteHelper.getCartPage());
                          //}
                        },
                        child: Stack(
                          children: [
                            //The blue background for the number of items
                            MyIcons(icon: Icons.shopping_cart_outlined),
                            Get.find<MealController>().totalItems >= 1
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    child: MyIcons(
                                      icon: Icons.circle,
                                      size: 20,
                                      iconColor: Colors.transparent,
                                      backgroundColor: Colors.blue,
                                    ),
                                  )
                                : Container(),
                            //The number of items
                            controller.totalItems >= 1
                                ? Positioned(
                                    right: 3,
                                    top: 3,
                                    child: LargeText(
                                      text: Get.find<MealController>()
                                          .totalItems
                                          .toString(),
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      );
                    }),
                  ],
                )),
            //Main info
            Positioned(
              //this comment for code formatting
              left: 0,
              right: 0,
              //we did bottom 0 so we take all the height available
              bottom: 0,
              //we do -20 so it overlaps the cover image and we can se the border edge
              top: Dimensions.restaurantCoverImg - 60,
              child: Container(
                padding: EdgeInsets.only(
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    top: Dimensions.height20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.radius20),
                    topLeft: Radius.circular(Dimensions.radius20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoRating(
                      text: restaurant.name,
                    ),
                    GetBuilder<RecommendedMealController>(
                        builder: (recommendedMeal) {
                      return recommendedMeal.isLoaded
                          ? ListView.builder(
                              //physics never thing so the whole poage is scrollable and not only the retaurant list
                              physics: NeverScrollableScrollPhysics(),
                              //ListView takes the height of the container it is in. Since the OG column does not have one we use shrinkWrap here even tho i am not exatly sure what it does
                              shrinkWrap: true,
                              itemCount:
                                  recommendedMeal.recommendedMealList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(RouteHelper.getRecommendedFood(
                                        index, "home"));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: Dimensions.width20,
                                        right: Dimensions.width20,
                                        bottom: Dimensions.height10),
                                    //Our main restaurant card
                                    child: Row(children: [
                                      //This container for the image
                                      Container(
                                        width: Dimensions.restaurantListImg,
                                        height: Dimensions.restaurantListImg,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radius20),
                                            //In future when we load images from the network, so if they do not load there will be a white background
                                            color: Colors.white38,
                                            image: DecorationImage(
                                              //We use this box fir so the image fits and looks like it has a border radius of 20
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  MyConstants.BASE_URL +
                                                      MyConstants.UPLOAD_URL +
                                                      recommendedMeal
                                                          .recommendedMealList[
                                                              index]
                                                          .img!),
                                            )),
                                      ),
                                      //Image Info container
                                      //We used Expanded widget so the width of thos info container takes all teh avaiable space
                                      Expanded(
                                        child: Container(
                                          height: Dimensions.restaurantListInfo,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(
                                                  Dimensions.radius20),
                                              bottomRight: Radius.circular(
                                                  Dimensions.radius20),
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: Dimensions.width10,
                                                right: Dimensions.width10),
                                            child: Column(
                                                //This crossAxisAlignment so everything is left aligned. crossAxis = horizontal
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                //mainAxis = vertical
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  LargeText(
                                                    text: recommendedMeal
                                                        .recommendedMealList[
                                                            index]
                                                        .name,
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions.height10,
                                                  ),
                                                  SmallText(
                                                    text:
                                                        "idk sone description goes here",
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions.height10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      DistanceTime(
                                                          icon: Icons
                                                              .circle_sharp,
                                                          text: "normal",
                                                          iconColor:
                                                              Colors.orange),
                                                      DistanceTime(
                                                          icon:
                                                              Icons.location_on,
                                                          text: "1.7km",
                                                          iconColor:
                                                              Colors.blue),
                                                      DistanceTime(
                                                          icon: Icons
                                                              .access_time_filled_rounded,
                                                          text: "32min",
                                                          iconColor:
                                                              Colors.red),
                                                    ],
                                                  )
                                                ]),
                                          ),
                                        ),
                                      )
                                    ]),
                                  ),
                                );
                              })
                          : CircularProgressIndicator(
                              color: Colors.red,
                            );
                    }),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    LargeText(text: "Information"),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //SingleChildScrollView so we can scroll thro the text but it does not work alone inside a column so we need to wrap it inside another widget which is Expnded
                    Expanded(
                      child: SingleChildScrollView(
                        child: CollapseText(
                          text: meal.description,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
          clipBehavior: Clip.none,
        ),
      ),
      //We use the bottom navigaton bar that comes with scaffold
      /*bottomNavigationBar: GetBuilder<MealController>(
        builder: (restaurantMeal) {
          return Container(
            height: Dimensions.bottomHeightBar,
            padding: EdgeInsets.only(
                top: Dimensions.height30,
                bottom: Dimensions.height30,
                left: Dimensions.width20,
                right: Dimensions.width20),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 240, 239, 239),
                borderRadius: BorderRadius.only(
                  //we sued *2 cuz i want 40
                  topLeft: Radius.circular(Dimensions.radius20 * 2),
                  topRight: Radius.circular(Dimensions.radius20 * 2),
                )),
            child: Row(
                //comment for formatting purposes
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //add or remove items
                  Container(
                      padding: EdgeInsets.only(
                          top: Dimensions.height20,
                          bottom: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              restaurantMeal.setQuantity(false);
                            },
                            child: Icon(
                              Icons.remove,
                              color: Color.fromARGB(255, 224, 224, 224),
                            ),
                          ),
                          SizedBox(
                            width: Dimensions.width10 / 2,
                          ),
                          LargeText(
                              text: restaurantMeal.incCartItems.toString()),
                          SizedBox(
                            width: Dimensions.width10 / 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              restaurantMeal.setQuantity(true);
                            },
                            child: Icon(
                              Icons.add,
                              color: Color.fromARGB(255, 224, 224, 224),
                            ),
                          ),
                        ],
                      )),
                  //Add to cart button
                  GestureDetector(
                    onTap: () {
                      //This will call the function isnidoe our meal controller then our cart controller
                      restaurantMeal.addItem(meal);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: Dimensions.height20,
                          bottom: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      child: LargeText(
                        text: "\$ ${meal.price!} | Add to cart",
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius20),
                        color: Colors.blue,
                      ),
                    ),
                  )
                ]),
          );
        },
      ),*/
    );
  }
}
