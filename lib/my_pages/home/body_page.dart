import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/meal_controller.dart';
import 'package:twaste/controllers/recommended_meals_controller.dart';
import 'package:twaste/controllers/restaurant_controller.dart';
import 'package:twaste/my_pages/restaurant/restaurant_page.dart';
import 'package:twaste/my_widgets/info_and_rating.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:twaste/my_widgets/distance_time.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:twaste/utils/my_constants.dart';

import '../../models/meal_model.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({super.key});

  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  //This viewport fraction is what gives us the look of the other entries to the left and right of the swiping
  PageController pageController = PageController(viewportFraction: 0.85);
  //This value is what we will use to determine the zoom in and zoom out while sliding left and right
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageVeiwContainer;

  //initState is a built in method inside any stateful class but if we wabt to use it we need to override it
  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      //We use setstate so we can update our ui real time
      setState(() {
        _currPageValue = pageController.page!;
        //print("value is " + _currPageValue.toString());
      });
    });
  }

  //We use dispose so once we leave a page it won't use it any more to avoid memory leak
  @override
  void dispose() {
    pageController.dispose();
    //VIP VIP At first we only had 1 page andother pages nested inside it but now we have multiple pages so we need to use this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //left right slide section
        //We used GetBuilder so we can get data directly from the server. It connects our controller with the ui
        GetBuilder<MealController>(builder: (meals) {
          return meals.isLoaded
              ? Container(
                  height: Dimensions.pageVeiw,
                  //This pageview builderis what is giving us the scroll left and right feature
                  child: PageView.builder(
                      controller: pageController,
                      itemCount: meals.mealList.length,
                      itemBuilder: (context, index) {
                        return _buildSwipe(index, meals.mealList[index]);
                      }),
                )
              : CircularProgressIndicator(); //Dis loading icon
        }),
        //dots section
        GetBuilder<MealController>(builder: (meals) {
          return DotsIndicator(
            //Some times it takes time to get the data. And dotsCount can't be zero, so we initialize it to 1 then when we get the data we make it the data length
            dotsCount: meals.mealList.length <= 0 ? 1 : meals.mealList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: Colors.blue,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        //Popular restaurants text section
        SizedBox(
          height: Dimensions.height30,
        ),
        //In order to use margin and padding we need contaier ?
        Container(
          margin: EdgeInsets.only(
              left: Dimensions.width30, bottom: Dimensions.height20),
          child: Row(
              //so everything comes down to the buttom
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LargeText(text: "Recommended"),
                SizedBox(width: Dimensions.width10),
                Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: LargeText(
                      text: ".",
                      color: Colors.black26,
                    )),
                SizedBox(width: Dimensions.width10),
                Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: SmallText(text: "Restaurants"),
                )
              ]),
        ),
        SizedBox(
          height: Dimensions.height30,
        ),
        //Recommended Restaurant list
        GetBuilder<RestaurantController>(builder: (restaurant) {
          return restaurant.isLoaded
              ? ListView.builder(
                  //physics never thing so the whole poage is scrollable and not only the retaurant list
                  physics: NeverScrollableScrollPhysics(),
                  //ListView takes the height of the container it is in. Since the OG column does not have one we use shrinkWrap here even tho i am not exatly sure what it does
                  shrinkWrap: true,
                  itemCount: restaurant.restaurantList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteHelper.getRestaurant(
                            restaurant.restaurantList[index].id, "home"));
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
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                //In future when we load images from the network, so if they do not load there will be a white background
                                color: Colors.white38,
                                image: DecorationImage(
                                  //We use this box fir so the image fits and looks like it has a border radius of 20
                                  fit: BoxFit.cover,
                                  image: NetworkImage(MyConstants.BASE_URL +
                                      MyConstants.UPLOAD_URL +
                                      restaurant.restaurantList[index].img!),
                                )),
                          ),
                          //Image Info container
                          //We used Expanded widget so the width of thos info container takes all teh avaiable space
                          Expanded(
                            child: Container(
                              height: Dimensions.restaurantListInfo,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(Dimensions.radius20),
                                  bottomRight:
                                      Radius.circular(Dimensions.radius20),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LargeText(
                                        text: restaurant
                                            .restaurantList[index].name,
                                      ),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      SmallText(
                                        text: "idk sone description goes here",
                                      ),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              icon: Icons
                                                  .access_time_filled_rounded,
                                              text: "32min",
                                              iconColor: Colors.red),
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
        //List of recommended restaurants or foods (i will decide later)
        //Every builder in flutter takes a function in their item builder, first is context and second is index which is the number of items
        GetBuilder<RecommendedMealController>(builder: (recommendedMeal) {
          return recommendedMeal.isLoaded
              ? ListView.builder(
                  //physics never thing so the whole poage is scrollable and not only the retaurant list
                  physics: NeverScrollableScrollPhysics(),
                  //ListView takes the height of the container it is in. Since the OG column does not have one we use shrinkWrap here even tho i am not exatly sure what it does
                  shrinkWrap: true,
                  itemCount: recommendedMeal.recommendedMealList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                            RouteHelper.getRecommendedFood(index, "home"));
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
                                borderRadius:
                                    BorderRadius.circular(Dimensions.radius20),
                                //In future when we load images from the network, so if they do not load there will be a white background
                                color: Colors.white38,
                                image: DecorationImage(
                                  //We use this box fir so the image fits and looks like it has a border radius of 20
                                  fit: BoxFit.cover,
                                  image: NetworkImage(MyConstants.BASE_URL +
                                      MyConstants.UPLOAD_URL +
                                      recommendedMeal
                                          .recommendedMealList[index].img!),
                                )),
                          ),
                          //Image Info container
                          //We used Expanded widget so the width of thos info container takes all teh avaiable space
                          Expanded(
                            child: Container(
                              height: Dimensions.restaurantListInfo,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(Dimensions.radius20),
                                  bottomRight:
                                      Radius.circular(Dimensions.radius20),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      LargeText(
                                        text: recommendedMeal
                                            .recommendedMealList[index].name,
                                      ),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      SmallText(
                                        text: "idk sone description goes here",
                                      ),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              icon: Icons
                                                  .access_time_filled_rounded,
                                              text: "32min",
                                              iconColor: Colors.red),
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
      ],
    );
  }

  Widget _buildSwipe(int index, ProductModel meal) {
    //For the image zoom we are gonna use an api
    Matrix4 matrix = new Matrix4.identity();
    //floor is rounding
    //This condition is for the current slide
    if (index == _currPageValue.floor()) {
      var currentScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currentTransition = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransition, 0);
    }
    //This condition is for the next slide
    else if (index == _currPageValue.floor() + 1) {
      var currentScale =
          _scaleFactor + (_currPageValue - index + 1) * (1 - _scaleFactor);
      var currentTransition = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1);
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransition, 0);
    }
    //prev sldie
    else if (index == _currPageValue.floor() - 1) {
      var currentScale = 1 - (_currPageValue - index) * (1 - _scaleFactor);
      var currentTransition = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1);
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransition, 0);
    } else {
      var currentScale = 0.8;
      var currentTransition = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransition, 0);
    }

    //We use trnsform for the zoom in and out
    return Transform(
      transform: matrix,
      //Stack so they stack on top of each other
      child: Stack(
        children: [
          GestureDetector(
            onTap: (() {
              //Basic Getx routing we use this line of code below for smaller apps but for larger apps we need a seperate routing folder
              //Get.to(() => RestaurantDetails());
              //So I changed this, the swipe section is for meals and not restaurants. Also not that this was popular products but The repo for popular products became for restaurants I think I changed that
              //Get.toNamed(RouteHelper.getRestaurant(index, "home"));
              Get.toNamed(RouteHelper.getRecommendedFood(index, "home"));
            }),
            child: Container(
              //The child container will take the whole sapce of the parent container s one of teh ways we can fix it is to use stack
              height: Dimensions.pageVeiwContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: Color(0xFF696969),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    //VIP if you get an error like type string don't match type strng just use ! to tell the compiler that this value won't be null
                    image: NetworkImage(MyConstants.BASE_URL +
                        MyConstants.UPLOAD_URL +
                        meal.img!),
                  )),
            ),
          ),
          //This is the container on top of the iamge
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              //The child container will take the whole sapce of the parent container s one of teh ways we can fix it is to use stack
              height: Dimensions.pageVeiwTextContainer,
              margin: EdgeInsets.only(
                  left: Dimensions.width30,
                  right: Dimensions.width30,
                  bottom: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFe8e8e8),
                      blurRadius: 5.0,
                      offset: Offset(0, 5),
                    ),
                    //This second box shadow is to cover the grey shadow to the left and right of the box
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-5, 0),
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(5, 0),
                    )
                  ]),
              child: Container(
                padding: EdgeInsets.only(
                    top: Dimensions.height15, left: 15, right: 15),
                child: infoRating(
                  text: meal.name!,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
