import 'package:flutter/material.dart';
import 'package:twaste/controllers/restaurant_controller.dart';
import 'package:twaste/my_pages/restaurant/add_meal_page.dart';
import 'package:twaste/my_widgets/myIcons.dart';
// ignore: unused_import
import 'package:twaste/my_widgets/collapse_text.dart';
import 'package:twaste/my_widgets/info_and_rating.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:twaste/utils/my_constants.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/recommended_meals_controller.dart';
import '../../controllers/user_controller.dart';
import '../../my_widgets/my_text.dart';
import '../../routes/route_helper.dart';

class RestaurantDetails extends StatelessWidget {
  final int pageId;
  final int index;
  final String page;
  const RestaurantDetails(
      {super.key,
      required this.pageId,
      required this.index,
      required this.page});

  @override
  Widget build(BuildContext context) {
    bool userLoggedIn = Get.find<AuthController>().userLoggedIn();
    if (userLoggedIn) {
      ///print("Why is this called like 3 rimes");
      Get.find<UserController>().getUserInfo();
    }

    //I commented the below line because I added it to the body page
    //Get.find<RecommendedMealController>().getRecommendedMealList(pageId);
    //Have an error with this cuz if pageId (aka restaurant id) is larger than the amomunt of meals we have we get an error
    /*var meal =
        Get.find<RecommendedMealController>().recommendedMealList[pageId];*/
    //The default random meal box (I scraped the idea Cuz for now I will add it manually and diffirent restaurants will have diffirent prices etc.)
    //var RandomMeal = Get.find<RecommendedMealController>().recommendedMealList[0];
    //I cant use List.where cuz then I get an error with hte img and name of the restaurant below in the code
    var restaurant = Get.find<RestaurantController>().restaurantList[index];
    //To initialize the number of products added to 0. Whenever a pager is built this function is called. In our whole app we only have 1 cart // we also passing the product / meal
    Get.find<RecommendedMealController>()
        .initProduct(Get.find<CartController>());
    //print("page id is " + pageId.toString());
    //print("meal name is " + meal.name.toString());

    return Scaffold(
      //This can be used to ad shades to the background img as well
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            //Co
            GetBuilder<RecommendedMealController>(builder: (recommendedMeal) {
              double stock = 0;
              if (recommendedMeal.stockItems > 2) {
                stock = recommendedMeal.stockItems.toDouble();
                if (stock > 6) {
                  stock = stock - ((stock - 6) * 0.4);
                }
              }

              double recoLength =
                  recommendedMeal.recommendedMealList.length.toDouble();
              if (recoLength > 6) {
                recoLength = recoLength - ((recoLength - 6) * 0.4);
              }
              return recommendedMeal.editing
                  ? Container(
                      //This is SOOO WRONG the height of the page should be dynamic... I need to change this later
                      height: ((Dimensions.height20 * 38) +
                          (Dimensions.height20 * recoLength * recoLength)),
                      //This adds a nice shade over the background img
                      color: Colors.black87,
                    )
                  : Container(
                      height: ((Dimensions.height20 * 38) +
                          ((Dimensions.height20 * stock * stock))),
                      color: Colors.black87,
                    );
            }),
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
                          //Trying to make the backgrund image a bit darker, need to configure this more later
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.dstATop),
                          image: NetworkImage(
                            MyConstants.BASE_URL +
                                MyConstants.UPLOAD_URL +
                                restaurant.img!,
                          ))),
                )),
            //Restaruant info. I added this to make it look like hte figma design
            Positioned(
              top: Dimensions.height10 * 10,
              left: Dimensions.width10 * 5,
              right: Dimensions.width10 * 5,
              child: Container(
                padding: EdgeInsets.only(
                  left: Dimensions.width45,
                  right: Dimensions.width45,
                  top: Dimensions.height45,
                  bottom: Dimensions.height15,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(Dimensions.radius20),
                    topLeft: Radius.circular(Dimensions.radius20),
                    bottomLeft: Radius.circular(Dimensions.radius20),
                    bottomRight: Radius.circular(Dimensions.radius20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoRating(
                        text: restaurant.name,
                        start: false,
                      ),
                    ]),
              ),
            ),
            //Restaurant logo
            Positioned(
              top: Dimensions.height10 * 4,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Dimensions.width10 * 10,
                    height: Dimensions.height10 * 10,
                    decoration: BoxDecoration(
                        //size/2 to make it a circle
                        borderRadius: BorderRadius.circular(100 / 2),
                        color: Colors.amber,
                        image: DecorationImage(
                            //Again fit so it fills the whole screen
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              MyConstants.BASE_URL +
                                  MyConstants.UPLOAD_URL +
                                  restaurant.img!,
                            )),
                        //This for bluring arounf logo
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          )
                        ]),
                  ),
                ],
              ),
            ),
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
                        child: MyIcons(
                          icon: Icons.arrow_back_ios,
                          size: Dimensions.width10 * 4,
                          iconSize: Dimensions.font16,
                        )),
                    //Showing the number of items in cart
                    GetBuilder<RecommendedMealController>(
                        builder: (controller) {
                      return GetBuilder<CartController>(
                          builder: (cartController) {
                        var cartList = cartController.getItems;
                        //we used stack cuz not all items might show up,so we keep it dynamic
                        return GestureDetector(
                          onTap: () async {
                            //if (controller.totalItems >= 1) {
                            await Get.find<CartController>().getRemaining();
                            for (var i = 0; i < cartList.length; i++) {
                              if (cartList[i].remaining! <= 0) {
                                await cartController
                                    .removeItemZero(cartList[i].product!);
                              }
                            }
                            Get.toNamed(RouteHelper.getCartPage());
                            //}
                          },
                          child: Stack(
                            children: [
                              //The blue background for the number of items
                              MyIcons(
                                icon: Icons.shopping_cart_outlined,
                                size: Dimensions.width10 * 4,
                                iconSize: Dimensions.font16,
                              ),
                              Get.find<RecommendedMealController>()
                                          .totalItems >=
                                      1
                                  ? Positioned(
                                      right: 0,
                                      top: 0,
                                      child: MyIcons(
                                        icon: Icons.circle,
                                        size: Dimensions.width20,
                                        iconSize: Dimensions.font16,
                                        iconColor: Colors.transparent,
                                        backgroundColor: Colors.blue,
                                      ),
                                    )
                                  : Container(),
                              //The number of items
                              controller.totalItems >= 1
                                  ? Positioned(
                                      right: Dimensions.width15 / 5,
                                      top: Dimensions.height15 / 5,
                                      child: LargeText(
                                        text: Get.find<
                                                RecommendedMealController>()
                                            .totalItems
                                            .toString(),
                                        size: Dimensions.font12,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        );
                      });
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
                    left: Dimensions.width15,
                    right: Dimensions.width15,
                    top: Dimensions.height15),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(

                      ///topRight: Radius.circular(Dimensions.radius20),
                      //topLeft: Radius.circular(Dimensions.radius20),
                      ),
                  //Originally this was white but I am trying to make it same as figma, this whole lower background
                  color: Color.fromARGB(255, 245, 243, 246),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*infoRating(
                      text: restaurant.name,
                    ),*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder<UserController>(builder: (userController) {
                          return GetBuilder<RecommendedMealController>(
                              builder: (recommendedMeal) {
                            bool vendor = false;
                            if (userController.userModel?.vendor_id == pageId) {
                              vendor = true;
                            }
                            return GestureDetector(
                              onTap: () {
                                if (vendor) {
                                  recommendedMeal.isEditing(pageId);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: Dimensions.height10,
                                    bottom: Dimensions.height10,
                                    left: Dimensions.width15,
                                    right: Dimensions.width15),
                                //I don't like how this button is made, with the decoration seperect from the text insdie child
                                decoration: vendor
                                    ? recommendedMeal.editing && userLoggedIn
                                        ? BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radius20),
                                            color: Colors.green,
                                          )
                                        : BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radius20),
                                            color: Colors.blue,
                                          )
                                    : BoxDecoration(),
                                child: vendor
                                    ? recommendedMeal.editing
                                        ? SmallText(
                                            text: "Save Changes",
                                            color: Colors.white,
                                          )
                                        : SmallText(
                                            text: "Edit meals left",
                                            color: Colors.white,
                                          )
                                    : SizedBox(),
                              ),
                            );
                          });
                        }),
                        //Space between the buttons
                        SizedBox(
                          width: Dimensions.width10,
                        ),
                        //Add meal button
                        GetBuilder<UserController>(builder: (userController) {
                          bool vendor = false;
                          if (userController.userModel?.vendor_id == pageId) {
                            vendor = true;
                          }
                          return GestureDetector(
                            onTap: () {
                              if (vendor) {
                                Get.to(() => AddMeal());
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: Dimensions.height10,
                                  bottom: Dimensions.height10,
                                  left: Dimensions.width15,
                                  right: Dimensions.width15),
                              //I don't like how this button is made, with the decoration seperect from the text insdie child
                              decoration: vendor && userLoggedIn
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.radius20),
                                      color: Colors.blue,
                                    )
                                  : BoxDecoration(),
                              child: vendor && userLoggedIn
                                  ? SmallText(
                                      text: "Add meal",
                                      color: Colors.white,
                                    )
                                  : SizedBox(),
                            ),
                          );
                        }),
                      ],
                    ),
                    GetBuilder<RecommendedMealController>(
                        builder: (recommendedMeal) {
                      return recommendedMeal.isLoaded
                          ? ListView.builder(
                              //physics never thing so the whole poage is scrollable and not only the retaurant list
                              physics: const NeverScrollableScrollPhysics(),
                              //ListView takes the height of the container it is in. Since the OG column does not have one we use shrinkWrap here even tho i am not exatly sure what it does
                              shrinkWrap: true,
                              itemCount:
                                  recommendedMeal.recommendedMealList.length,
                              itemBuilder: (context, index) {
                                return recommendedMeal.editing
                                    ? GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                              RouteHelper.getRecommendedFood(
                                                  index, "home"));
                                        },
                                        child: Container(
                                          //This to see the borders of the contauner, for testing purposes
                                          //color: Colors.black87,
                                          margin: EdgeInsets.only(
                                              top: Dimensions.height10,
                                              left: Dimensions.width20,
                                              right: Dimensions.width20,
                                              bottom: Dimensions.height30),
                                          //Our main restaurant card
                                          child: Row(children: [
                                            //This container for the image
                                            Container(
                                              width:
                                                  Dimensions.restaurantListImg,
                                              height:
                                                  Dimensions.restaurantListImg,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions.radius20),
                                                  //In future when we load images from the network, so if they do not load there will be a white background
                                                  color: Colors.white38,
                                                  image: DecorationImage(
                                                    //We use this box fir so the image fits and looks like it has a border radius of 20
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(MyConstants
                                                            .BASE_URL +
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
                                                height: Dimensions
                                                        .restaurantListInfo +
                                                    Dimensions.height10,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight: Radius.circular(
                                                        Dimensions.radius20),
                                                    bottomRight:
                                                        Radius.circular(
                                                            Dimensions
                                                                .radius20),
                                                  ),
                                                  //THis was origanlly white as well but trying to make it same figma desig, this for background of item
                                                  color: const Color.fromARGB(
                                                      255, 245, 243, 246),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: Dimensions.width10,
                                                      right: 0),
                                                  child: Column(
                                                      //This crossAxisAlignment so everything is left aligned. crossAxis = horizontal
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      //mainAxis = vertical
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        LargeText(
                                                          text: recommendedMeal
                                                              .recommendedMealList[
                                                                  index]
                                                              .name,
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .height10,
                                                        ),
                                                        SmallText(
                                                          text: recommendedMeal
                                                              .recommendedMealList[
                                                                  index]
                                                              .description,
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                                  .height10 /
                                                              2,
                                                        ),
                                                        //Meal price, and adding meal to cart
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                //Might remove the %off later
                                                                /*LargeText(
                                                                  text:
                                                                      '60% off',
                                                                  size: 10,
                                                                ),*/
                                                                Text(
                                                                    recommendedMeal
                                                                            .recommendedMealList[
                                                                                index]
                                                                            .price
                                                                            .toString() +
                                                                        ' AED',
                                                                    style: TextStyle(
                                                                        decoration:
                                                                            TextDecoration
                                                                                .lineThrough,
                                                                        fontSize:
                                                                            Dimensions.font12)),
                                                                LargeText(
                                                                  text: recommendedMeal
                                                                          .recommendedMealList[
                                                                              index]
                                                                          .newPrice
                                                                          .toString() +
                                                                      ' AED',
                                                                  size: Dimensions
                                                                      .font16,
                                                                ),
                                                              ],
                                                            ),
                                                            //Here is the remaining meals when editing
                                                            Column(
                                                              children: [
                                                                recommendedMeal
                                                                        .editing
                                                                    ? Row(
                                                                        children: [
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              recommendedMeal.setQuantityRemaining(false, index);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.remove,
                                                                              color: Colors.black,
                                                                              size: Dimensions.iconSize16,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                Dimensions.width10 / 2,
                                                                          ),
                                                                          SmallText(
                                                                            //maybe bblack maybe red depnding on amount left
                                                                            color:
                                                                                Colors.green,
                                                                            size:
                                                                                Dimensions.font12 * 1.2,
                                                                            text:
                                                                                "${recommendedMeal.remaining[index]} left",
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                Dimensions.width10 / 2,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              recommendedMeal.setQuantityRemaining(true, index);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.add,
                                                                              color: Colors.blue,
                                                                              size: Dimensions.iconSize16,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : Row(
                                                                        children: [
                                                                          SmallText(
                                                                            //maybe bblack maybe red depnding on amount left
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                Dimensions.font12 * 1.2,
                                                                            text:
                                                                                "${recommendedMeal.remaining[index]} left",
                                                                          ),
                                                                        ],
                                                                      ),
                                                                //Here is the adding item to cart button
                                                                /*Container(
                                                                    padding: EdgeInsets.only(
                                                                        top: Dimensions.height10 /
                                                                            4,
                                                                        bottom:
                                                                            Dimensions.height10 /
                                                                                4,
                                                                        left: Dimensions.width10 /
                                                                            3,
                                                                        right: Dimensions.width10 /
                                                                            3),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Dimensions.radius20),
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            recommendedMeal.setQuantity(false,
                                                                                index);
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons.remove,
                                                                            color:
                                                                                Colors.black,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              Dimensions.width10 / 2,
                                                                        ),
                                                                        /*GetBuilder<
                                                                          CartController>(
                                                                      builder:
                                                                          (cartController) {
                                                                    var _cartList =
                                                                        cartController
                                                                            .getItems;
                                                                    var _cListId =
                                                                        _cartList
                                                                            .map((v) =>
                                                                                v.id)
                                                                            .toList();
                                                                    //This took me an hour to figure out haha, thought I can't use if else conditions, also forgot if the index of the item was not found it returns -1
                                                                    //At the end I commented it out but it is good to have if I want to show the number of meals I have in cart for that certain item, 
                                                                    var mealIndex = _cListId.indexOf(
                                                                        recommendedMeal
                                                                            .recommendedMealList[
                                                                                index]
                                                                            .id);
                                                                    if (mealIndex <
                                                                        0) {
                                                                      return LargeText(
                                                                          text:
                                                                              "0");
                                                                    } else {
                                                                      return LargeText(
                                                                        text: _cartList[
                                                                                mealIndex]
                                                                            .quantity
                                                                            .toString(),
                                                                      );
                                                                    }
                                                                  }),*/
                                                                        LargeText(
                                                                            text:
                                                                                "${recommendedMeal.quantity[index]} "),
                                                                        /*LargeText(
                                                              text: _cartList[index]
                                                                  .quantity
                                                                  .toString()), //restaurantMeal.incCartItems.toString(),*/
                                                                        SizedBox(
                                                                          width:
                                                                              Dimensions.width10 / 2,
                                                                        ),
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            recommendedMeal.setQuantity(true,
                                                                                index);
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                Colors.blue,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )),*/
                                                              ],
                                                            ),
                                                            //Here it should end
                                                            GestureDetector(
                                                              onTap: () {
                                                                recommendedMeal.removeItem(
                                                                    recommendedMeal
                                                                        .recommendedMealList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                                size: Dimensions
                                                                    .iconSize24,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            )
                                          ]),
                                        ),
                                      )
                                    : recommendedMeal.recommendedMealList[index]
                                                .remaining !=
                                            0
                                        ? GestureDetector(
                                            onTap: () {
                                              Get.toNamed(RouteHelper
                                                  .getRecommendedFood(
                                                      index, "home"));
                                            },
                                            child: Container(
                                              //This to see the borders of the contauner, for testing purposes
                                              //color: Colors.black87,
                                              margin: EdgeInsets.only(
                                                  top: Dimensions.height10,
                                                  left: Dimensions.width20,
                                                  right: Dimensions.width20,
                                                  bottom: Dimensions.height30),
                                              //Our main restaurant card
                                              child: Row(children: [
                                                //This container for the image
                                                Container(
                                                  width: Dimensions
                                                      .restaurantListImg,
                                                  height: Dimensions
                                                      .restaurantListImg,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimensions
                                                                  .radius20),
                                                      //In future when we load images from the network, so if they do not load there will be a white background
                                                      color: Colors.white38,
                                                      image: DecorationImage(
                                                        //We use this box fir so the image fits and looks like it has a border radius of 20
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            MyConstants
                                                                    .BASE_URL +
                                                                MyConstants
                                                                    .UPLOAD_URL +
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
                                                    height: Dimensions
                                                            .restaurantListInfo +
                                                        Dimensions.height10,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(
                                                                Dimensions
                                                                    .radius20),
                                                        bottomRight:
                                                            Radius.circular(
                                                                Dimensions
                                                                    .radius20),
                                                      ),
                                                      //THis was origanlly white as well but trying to make it same figma desig, this for background of item
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              245,
                                                              243,
                                                              246),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: Dimensions
                                                              .width10,
                                                          right: 0),
                                                      child: Column(
                                                          //This crossAxisAlignment so everything is left aligned. crossAxis = horizontal
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          //mainAxis = vertical
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            LargeText(
                                                              text: recommendedMeal
                                                                  .recommendedMealList[
                                                                      index]
                                                                  .name,
                                                            ),
                                                            SizedBox(
                                                              height: Dimensions
                                                                  .height10,
                                                            ),
                                                            SmallText(
                                                              text: recommendedMeal
                                                                  .recommendedMealList[
                                                                      index]
                                                                  .description,
                                                            ),
                                                            SizedBox(
                                                              height: Dimensions
                                                                      .height10 /
                                                                  2,
                                                            ),
                                                            //Meal price, and adding meal to cart
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Column(
                                                                  children: [
                                                                    //Might remove the %off later
                                                                    /*LargeText(
                                                                      text:
                                                                          '60% off',
                                                                      size: 10,
                                                                    ),*/
                                                                    Text(
                                                                        recommendedMeal.recommendedMealList[index].price.toString() +
                                                                            ' AED',
                                                                        style: TextStyle(
                                                                            decoration:
                                                                                TextDecoration.lineThrough,
                                                                            fontSize: Dimensions.font12)),
                                                                    LargeText(
                                                                      text: recommendedMeal
                                                                              .recommendedMealList[index]
                                                                              .newPrice
                                                                              .toString() +
                                                                          ' AED',
                                                                      size: Dimensions
                                                                          .font16,
                                                                    ),
                                                                  ],
                                                                ),
                                                                //Here is the remaining meals when editing
                                                                Column(
                                                                  children: [
                                                                    recommendedMeal
                                                                            .editing
                                                                        ? Row(
                                                                            children: [
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  recommendedMeal.setQuantityRemaining(false, index);
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.remove,
                                                                                  color: Colors.black,
                                                                                  size: Dimensions.iconSize16,
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: Dimensions.width10 / 2,
                                                                              ),
                                                                              SmallText(
                                                                                //maybe bblack maybe red depnding on amount left
                                                                                color: Colors.green,
                                                                                size: Dimensions.font12 * 1.2,
                                                                                text: "${recommendedMeal.remaining[index]} left",
                                                                              ),
                                                                              SizedBox(
                                                                                width: Dimensions.width10 / 2,
                                                                              ),
                                                                              GestureDetector(
                                                                                onTap: () {
                                                                                  recommendedMeal.setQuantityRemaining(true, index);
                                                                                },
                                                                                child: Icon(
                                                                                  Icons.add,
                                                                                  color: Colors.blue,
                                                                                  size: Dimensions.iconSize16,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : Row(
                                                                            children: [
                                                                              SmallText(
                                                                                //maybe bblack maybe red depnding on amount left
                                                                                color: Colors.red,
                                                                                size: Dimensions.font12 * 1,
                                                                                text: "${recommendedMeal.remaining[index]} left",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                    //Here is the adding item to cart button
                                                                    Container(
                                                                        padding: EdgeInsets.only(
                                                                            top: Dimensions.height10 /
                                                                                4,
                                                                            bottom: Dimensions.height10 /
                                                                                4,
                                                                            left: Dimensions.width10 /
                                                                                3,
                                                                            right: Dimensions.width10 /
                                                                                3),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimensions.radius20),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                recommendedMeal.setQuantity(false, index);
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.remove,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: Dimensions.width10 / 2,
                                                                            ),
                                                                            /*GetBuilder<
                                                                          CartController>(
                                                                      builder:
                                                                          (cartController) {
                                                                    var _cartList =
                                                                        cartController
                                                                            .getItems;
                                                                    var _cListId =
                                                                        _cartList
                                                                            .map((v) =>
                                                                                v.id)
                                                                            .toList();
                                                                    //This took me an hour to figure out haha, thought I can't use if else conditions, also forgot if the index of the item was not found it returns -1
                                                                    //At the end I commented it out but it is good to have if I want to show the number of meals I have in cart for that certain item, 
                                                                    var mealIndex = _cListId.indexOf(
                                                                        recommendedMeal
                                                                            .recommendedMealList[
                                                                                index]
                                                                            .id);
                                                                    if (mealIndex <
                                                                        0) {
                                                                      return LargeText(
                                                                          text:
                                                                              "0");
                                                                    } else {
                                                                      return LargeText(
                                                                        text: _cartList[
                                                                                mealIndex]
                                                                            .quantity
                                                                            .toString(),
                                                                      );
                                                                    }
                                                                  }),*/
                                                                            LargeText(text: "${recommendedMeal.quantity[index]} "),
                                                                            /*LargeText(
                                                              text: _cartList[index]
                                                                  .quantity
                                                                  .toString()), //restaurantMeal.incCartItems.toString(),*/
                                                                            SizedBox(
                                                                              width: Dimensions.width10 / 2,
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                recommendedMeal.setQuantity(true, index);
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.add,
                                                                                color: Colors.blue,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                  ],
                                                                ),
                                                                //Here it should end
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    recommendedMeal.addItem(
                                                                        recommendedMeal
                                                                            .recommendedMealList[index],
                                                                        index);
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.only(
                                                                        top: Dimensions
                                                                            .height10,
                                                                        bottom: Dimensions
                                                                            .height10,
                                                                        left: Dimensions
                                                                            .width15,
                                                                        right: Dimensions
                                                                            .width15),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Dimensions.radius20),
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    child:
                                                                        SmallText(
                                                                      text:
                                                                          "Add",
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ]),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                            ),
                                          )
                                        : const SizedBox();
                              })
                          : const CircularProgressIndicator(
                              color: Colors.red,
                            );
                    }),
                    /*SizedBox(
                      height: Dimensions.height20,
                    ),
                    LargeText(text: "Information"),
                    SizedBox(
                      height: Dimensions.height20,
                    ),
                    //SingleChildScrollView so we can scroll thro the text but it does not work alone inside a column so we need to wrap it inside another widget which is Expnded
                    const Expanded(
                      child: SingleChildScrollView(
                        child: CollapseText(
                          text: "meal.description",
                        ),
                      ),
                    )*/
                  ],
                ),
              ),
            ),
          ],
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
