import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/meal_controller.dart';
import 'package:twaste/controllers/recommended_meals_controller.dart';
import 'package:twaste/my_widgets/myIcons.dart';
import 'package:twaste/my_widgets/collapse_text.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../controllers/cart_controller.dart';
import '../../utils/my_constants.dart';

class Meal extends StatelessWidget {
  final int pageId;
  final String page;
  const Meal({super.key, required this.pageId, required this.page});

  @override
  Widget build(BuildContext context) {
    var meal =
        Get.find<RecommendedMealController>().recommendedMealList[pageId];
    //This is VIP so we initialize and ready the cart
    Get.find<MealController>().initProduct(meal, Get.find<CartController>());
    return Scaffold(
      backgroundColor: Colors.white,
      //CustomScrollView takes slivers
      //Image and info
      body: CustomScrollView(
        //Sliver kinda like speacial effects / features
        slivers: [
          //Image and header
          SliverAppBar(
            //automaticallyImplyLeading automatically adds a back arrow for us. Since we already made our own back button we don't need it
            automaticallyImplyLeading: false,
            toolbarHeight: 70,
            //for the icons
            title: Row(
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
                  child: const MyIcons(icon: Icons.clear),
                ),
                //MyIcons(icon: Icons.shopping_cart_outlined)
                //Here we are making an instance of the MealController and we called it controller
                GetBuilder<MealController>(builder: (controller) {
                  //we used stack cuz not all items might show up,so we keep it dynamic
                  return GestureDetector(
                    onTap: () {
                      //if (controller.totalItems >= 1) {
                      //print("I am bonked");
                      Get.toNamed(RouteHelper.getCartPage());
                      //}
                    },
                    child: Stack(
                      children: [
                        //The blue background for the number of items
                        const MyIcons(icon: Icons.shopping_cart_outlined),
                        Get.find<MealController>().totalItems >= 1
                            ? const Positioned(
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
                        Get.find<MealController>().totalItems >= 1
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
                })
              ],
            ),
            //this bottom for the text above that will stay attatched
            bottom: PreferredSize(
              //This let us see more of the pinned bar thing
              preferredSize: const Size.fromHeight(30),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.radius20),
                    topRight: Radius.circular(Dimensions.radius20),
                  ),
                ),
                child: Center(
                    child: LargeText(size: Dimensions.font26, text: meal.name)),
              ),
            ),

            //The pinned and background color is like the above thing when the image is gone
            pinned: true,
            backgroundColor: Colors.green,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                  MyConstants.BASE_URL + MyConstants.UPLOAD_URL + meal.img!,
                  width: double.maxFinite,
                  //So the image takes the whole space
                  fit: BoxFit.cover),
            ),
          ),
          //info
          SliverToBoxAdapter(
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(
                    left: Dimensions.width20, right: Dimensions.width20),
                child: CollapseText(
                  text: meal.description!,
                ),
              )
            ]),
          )
        ],
      ),
      //for add to cart and favorite
      //We use GetBuilder so we can use the controller and its functions like setQuantity
      bottomNavigationBar: GetBuilder<MealController>(builder: (controller) {
        return Column(
          //We use trhis mainAxisSize because our column is not wrapped inside a container (scaffold is not a good one) and cuz of that colummn is taking the whole page
          mainAxisSize: MainAxisSize.min,
          children: [
            //add and subtract
            Container(
              padding: EdgeInsets.only(
                left: Dimensions.width20 * 2.5,
                right: Dimensions.width20 * 2.5,
                top: Dimensions.height10,
                bottom: Dimensions.height10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      controller.setQuantity(false);
                    },
                    child: MyIcons(
                        iconSize: Dimensions.iconSize24,
                        backgroundColor: Colors.blue,
                        iconColor: Colors.white,
                        icon: Icons.remove),
                  ),
                  LargeText(
                    text: "\$ ${meal.price!}  X | ${controller.incCartItems} ",
                    size: Dimensions.font26,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.setQuantity(true);
                    },
                    child: MyIcons(
                        iconSize: Dimensions.iconSize24,
                        backgroundColor: Colors.blue,
                        iconColor: Colors.white,
                        icon: Icons.add),
                  ),
                ],
              ),
            ),
            //favorite and add to cart
            Container(
              height: Dimensions.bottomHeightBar,
              padding: EdgeInsets.only(
                  top: Dimensions.height30,
                  bottom: Dimensions.height30,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 239, 239),
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
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.blue,
                      ),
                    ),
                    //Add to cart button
                    GestureDetector(
                      onTap: () {
                        controller.addItem(meal);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            top: Dimensions.height20,
                            bottom: Dimensions.height20,
                            left: Dimensions.width20,
                            right: Dimensions.width20),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius20),
                          color: Colors.blue,
                        ),
                        child: LargeText(
                          text: "\$ ${meal.price} | Add to cart",
                          color: Colors.white,
                        ),
                      ),
                    )
                  ]),
            ),
          ],
        );
      }),
    );
  }
}
