import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/base/common_text_button.dart';
import 'package:twaste/base/no_data_page.dart';
import 'package:twaste/base/show_custom_snackBar.dart';
import 'package:twaste/controllers/auth_controller.dart';
import 'package:twaste/controllers/cart_controller.dart';
import 'package:twaste/controllers/location_controller.dart';
import 'package:twaste/controllers/meal_controller.dart';
import 'package:twaste/controllers/order_controller.dart';
import 'package:twaste/controllers/user_controller.dart';
import 'package:twaste/my_pages/order/delivery_options.dart';
import 'package:twaste/my_widgets/input_field.dart';
import 'package:twaste/my_widgets/myIcons.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/my_pages/order/payment_option_button.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/my_constants.dart';
import 'package:twaste/utils/styles.dart';

import '../../controllers/recommended_meals_controller.dart';
import '../../models/place_order_model.dart';
import '../../utils/dimensions.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

//Made this cart page to a sateful widget and added this initState so I show the snackbar once the whole page has been built
class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do something
      var removedItems = Get.find<CartController>().itemsRemoved;
      for (var element in removedItems) {
        Get.snackbar("Item count",
            "Product ${element.name} is no longer available and was removed",
            backgroundColor: Colors.orange, colorText: Colors.white);
      }
      Get.find<CartController>().itemsRemovedClear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController noteController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          //Icnons back home and cart
          Positioned(
              left: Dimensions.width20,
              right: Dimensions.width20,
              top: Dimensions.height20 * 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back(result: 'hello');
                    },
                    child: MyIcons(
                      icon: Icons.arrow_back_ios,
                      iconColor: Colors.white,
                      backgroundColor: Colors.blue,
                      size: Dimensions.width10 * 4,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.width20 * 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      //Get.to(() => HomePage());
                      Get.toNamed(RouteHelper.getInitial());
                    },
                    child: MyIcons(
                      icon: Icons.home_outlined,
                      iconColor: Colors.white,
                      backgroundColor: Colors.blue,
                      size: Dimensions.width10 * 4,
                      iconSize: Dimensions.iconSize24,
                    ),
                  ),
                ],
              )),
          //We using postiotned here cuz we want this section to be scrollable
          GetBuilder<CartController>(builder: (cartController) {
            return cartController.getItems.isNotEmpty
                ? Positioned(
                    top: Dimensions.height20 * 5,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    bottom: 0,
                    child: Container(
                      margin: EdgeInsets.only(top: Dimensions.height15),
                      //for debugging purposes
                      //color: Colors.red,
                      child:
                          //We added the mediaquery and context and remove top so we can remove the default top padding that comes with ListView.builer
                          MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child:
                            //So we can use the cart controlelr
                            GetBuilder<CartController>(
                                builder: (cartController) {
                          var cartList = cartController.getItems;
                          return ListView.builder(
                              itemCount: cartList.length,
                              itemBuilder: (_, index) {
                                return SizedBox(
                                  height: Dimensions.height20 * 5,
                                  //to take all available space
                                  width: double.maxFinite,
                                  //Rows for items in cart
                                  child: Row(
                                    children: [
                                      //Image for the item
                                      GestureDetector(
                                        onTap: () {
                                          //Getting the index of the meal that we want in the meal list
                                          var mealIndex =
                                              Get.find<MealController>()
                                                  .mealList
                                                  .indexOf(
                                                      cartList[index].product);
                                          //if found the index of the item in our mealList
                                          if (mealIndex >= 0) {
                                            Get.toNamed(
                                                RouteHelper.getRestaurant(
                                                    mealIndex,
                                                    mealIndex,
                                                    "cartpage"));
                                          }
                                          //else it must be on our other recommendedMealList
                                          else {
                                            var recommendedIndex = Get.find<
                                                    RecommendedMealController>()
                                                .recommendedMealList
                                                .indexOf(
                                                    cartList[index].product);
                                            //If we can't find it in the recommended list
                                            if (recommendedIndex < 0) {
                                              Get.snackbar("Item not found",
                                                  "Error could not find item",
                                                  backgroundColor: Colors.blue,
                                                  colorText: Colors.white);
                                            } else {
                                              Get.toNamed(RouteHelper
                                                  .getRecommendedFood(
                                                      recommendedIndex,
                                                      "cartpage"));
                                            }
                                          }
                                        },
                                        child: Container(
                                          width: Dimensions.height20 * 5,
                                          height: Dimensions.height20 * 5,
                                          margin: EdgeInsets.only(
                                              bottom: Dimensions.height10),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              //VIP we need this so the image fills the box
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  MyConstants.BASE_URL +
                                                      MyConstants.UPLOAD_URL +
                                                      cartController
                                                          .getItems[index]
                                                          .img!),
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.radius20),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dimensions.width10,
                                      ),
                                      //Info of item
                                      //Container inside expanded widget takes all the available space of the parent widget so that is why we used expanded
                                      Expanded(
                                          child: SizedBox(
                                        height: Dimensions.height20 * 5,
                                        child: Column(
                                          //So all our info start fromn the right
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          //So all of our info is spaced equally
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            LargeText(
                                              text: cartController
                                                  .getItems[index].name!,
                                              color: Colors.black54,
                                            ),
                                            SmallText(text: "Spicy"),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                //price of item
                                                LargeText(
                                                  text:
                                                      "\$ ${cartController.getItems[index].price}",
                                                  color: Colors.redAccent,
                                                ),
                                                //add or remove item
                                                Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SmallText(
                                                          //maybe bblack maybe red depnding on amount left
                                                          color: Colors.red,
                                                          size: Dimensions
                                                                  .font12 *
                                                              1.2,
                                                          text:
                                                              "${cartController.getItems[index].remaining} left",
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                        padding: EdgeInsets.only(
                                                            top: Dimensions
                                                                    .height10 /
                                                                2,
                                                            bottom: Dimensions
                                                                    .height10 /
                                                                2,
                                                            left: Dimensions
                                                                    .width10 /
                                                                2,
                                                            right: Dimensions
                                                                    .width10 /
                                                                2),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  Dimensions
                                                                      .radius20),
                                                          color: Colors.white,
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                cartController.addItem(
                                                                    cartList[
                                                                            index]
                                                                        .product!,
                                                                    -1);
                                                              },
                                                              child: Icon(
                                                                Icons.remove,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        224,
                                                                        224,
                                                                        224),
                                                                size: Dimensions
                                                                    .width30,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: Dimensions
                                                                      .width10 /
                                                                  2,
                                                            ),
                                                            LargeText(
                                                                text: cartList[
                                                                        index]
                                                                    .quantity
                                                                    .toString()), //restaurantMeal.incCartItems.toString(),
                                                            SizedBox(
                                                              width: Dimensions
                                                                      .width10 /
                                                                  2,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                cartController.addItem(
                                                                    cartList[
                                                                            index]
                                                                        .product!,
                                                                    1);
                                                              },
                                                              child: Icon(
                                                                Icons.add,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        224,
                                                                        224,
                                                                        224),
                                                                size: Dimensions
                                                                    .width30,
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                );
                              });
                        }),
                      ),
                    ))
                : const NoDataPage(text: "Your cart is empty!");
          })
        ],
      ),
      //our bottom section
      bottomNavigationBar:
          GetBuilder<OrderController>(builder: (orderController) {
        noteController.text = orderController.orderNote;
        return GetBuilder<CartController>(
          builder: (cartController) {
            return Container(
              //For now added 50 so I don't have any overflow issues
              height: Dimensions.bottomHeightBar + 50,
              padding: EdgeInsets.only(
                  top: Dimensions.height10,
                  bottom: Dimensions.height10,
                  left: Dimensions.width20,
                  right: Dimensions.width20),
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 239, 239),
                  borderRadius: BorderRadius.only(
                    //we sued *2 cuz i want 40
                    topLeft: Radius.circular(Dimensions.radius20 * 2),
                    topRight: Radius.circular(Dimensions.radius20 * 2),
                  )),
              child: cartController.getItems.isNotEmpty
                  ? Column(
                      children: [
                        //Inkwell for clickable button
                        InkWell(
                          //showModalBottomSheet so when i click the payment options button it gives me that pop up
                          onTap: () => showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (_) {
                                    return Column(
                                      children: [
                                        //And Expanded Widget needs to be insode column otherwise we get an overflow error
                                        Expanded(
                                          //This so it can be scrolable and it needs to be wraped inside an expanded widget
                                          child: SingleChildScrollView(
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(
                                                      Dimensions.radius20),
                                                  topRight: Radius.circular(
                                                      Dimensions.radius20),
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.9,
                                                    //Padding so the buttons do not take the whole sapce
                                                    padding: EdgeInsets.only(
                                                      left: Dimensions.width20,
                                                      right: Dimensions.width20,
                                                      top: Dimensions.height20,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const PaymentOptionButton(
                                                          icon: Icons.money,
                                                          index: 0,
                                                          subTitle:
                                                              'you pay on delivery',
                                                          title:
                                                              'Cash on delivery',
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .height10,
                                                        ),
                                                        const PaymentOptionButton(
                                                          icon:
                                                              Icons.credit_card,
                                                          index: 1,
                                                          subTitle:
                                                              'Visa or Master Cards',
                                                          title:
                                                              'Digital Payments',
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .height30,
                                                        ),
                                                        Text(
                                                          "Delivery options",
                                                          style: robotoMedium,
                                                        ),
                                                        SizedBox(
                                                          height: Dimensions
                                                                  .height10 /
                                                              2,
                                                        ),
                                                        DeliveryOptions(
                                                            value: "delivery",
                                                            title:
                                                                "Home delivery",
                                                            amount: double
                                                                .parse(Get.find<
                                                                        CartController>()
                                                                    .totalAmount
                                                                    .toString()),
                                                            isFree: false),
                                                        SizedBox(
                                                          height: Dimensions
                                                                  .height10 /
                                                              2,
                                                        ),
                                                        DeliveryOptions(
                                                            value: "take away",
                                                            title: "Take away",
                                                            amount: double
                                                                .parse(Get.find<
                                                                        CartController>()
                                                                    .totalAmount
                                                                    .toString()),
                                                            isFree: true),
                                                        SizedBox(
                                                          height: Dimensions
                                                              .height20,
                                                        ),
                                                        Text(
                                                          "Order Notes",
                                                          style: robotoMedium,
                                                        ),
                                                        InputField(
                                                          textController:
                                                              noteController,
                                                          hintText: '',
                                                          icon: Icons.note,
                                                          maxLines: true,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                              .whenComplete(() => orderController.setFoodNote(
                                  noteController.text
                                      .trim())), //trim removes all empty spaces
                          child: const SizedBox(
                            width: double.maxFinite,
                            child: CommonTextButton(text: "Payment Options"),
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.height10,
                        ),
                        Row(
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
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.radius20),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: Dimensions.width10 / 2,
                                      ),
                                      LargeText(
                                          text:
                                              "\$ ${cartController.totalAmount.toString()}"),
                                      SizedBox(
                                        width: Dimensions.width10 / 2,
                                      ),
                                    ],
                                  )),
                              //Checkout button
                              GestureDetector(
                                onTap: () async {
                                  //Checking if user has logged in or not
                                  if (Get.find<AuthController>()
                                      .userLoggedIn()) {
                                    //making sure we have this device's token
                                    Get.find<AuthController>().updateToken();
                                    if (Get.find<LocationController>()
                                        .addressList
                                        .isEmpty) {
                                      Get.toNamed(RouteHelper.getAddressPage());
                                    } else {
                                      //Get.snackbar("Item count", "You can't reduce more!", backgroundColor: Colors.blue, colorText: Colors.white);
                                      var location =
                                          Get.find<LocationController>()
                                              .getUserAddress();
                                      var cart =
                                          Get.find<CartController>().getItems;
                                      var user =
                                          Get.find<UserController>().userModel;
                                      //This is our place order model, some variables are fixed for now
                                      PlaceOrderBody placeOrder =
                                          PlaceOrderBody(
                                        cart: cart,
                                        orderAmount: 100.0,
                                        orderNote: orderController.orderNote,
                                        address: location.address,
                                        latitude: location.latitude,
                                        longitude: location.longitude,
                                        contactPersonName: user!.name,
                                        contactPersonNumber: user.phone,
                                        scheduleAt: '',
                                        distance: 10.0,
                                        orderType: orderController.orderType,
                                        paymentMethod:
                                            orderController.paymentIndex == 0
                                                ? 'cash_on_delivery'
                                                : 'digital_payment',
                                      );

                                      //_callBack is a function that we will pass to our controller and then the controller will send us BACK the info that we need
                                      await Get.find<OrderController>()
                                          .placeOrder(placeOrder, _callback);
                                      cartController.addToHistory();
                                    }
                                  } else {
                                    Get.toNamed(RouteHelper.getSignInPage());
                                  }
                                },
                                child:
                                    const CommonTextButton(text: "Check Out"),
                              )
                            ])
                      ],
                    )
                  : Container(),
            );
          },
        );
      }),
    );
  }

  void _callback(bool isSucces, String message, String orderID) {
    if (isSucces) {
      Get.find<CartController>().clear();
      Get.find<CartController>().removeCartSharedPreference();
      Get.find<CartController>().addToHistory();
      //If it is cash
      if (Get.find<OrderController>().paymentIndex == 0) {
        Get.offNamed(RouteHelper.getOrderSuccessPage(orderID, "success"));
      } else {
        Get.offNamed(RouteHelper.getPaymentPage(
            orderID, Get.find<UserController>().userModel!.id));
      }
    } else {
      showCusotmSnackBar(message);
    }
  }
}
