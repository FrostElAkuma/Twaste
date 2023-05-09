import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twaste/base/no_data_page.dart';
import 'package:twaste/controllers/cart_controller.dart';
import 'package:twaste/my_widgets/myIcons.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:twaste/utils/my_constants.dart';

class CartHistory extends StatelessWidget {
  const CartHistory({super.key});

  @override
  Widget build(BuildContext context) {
    //We use Get.find so we can use the cart controller. We used reverse so the latest order is at the top. When we used revered it becomes an itterable object and we need to use keys so we use .toList
    var getCartHistoryList =
        Get.find<CartController>().getCartHistoryList().reversed.toList();

    Map<String, int> cartItemsPerOrder = {};

    for (int i = 0; i < getCartHistoryList.length; i++) {
      if (cartItemsPerOrder.containsKey(getCartHistoryList[i].time)) {
        cartItemsPerOrder.update(
            getCartHistoryList[i].time!, (value) => ++value);
      } else {
        cartItemsPerOrder.putIfAbsent(getCartHistoryList[i].time!, () => 1);
      }
    }

    List<int> cartitemsPerOrderToList() {
      return cartItemsPerOrder.entries.map((e) => e.value).toList();
    }

    List<int> itemsPerOrder = cartitemsPerOrderToList();

    var listCounter = 0;

    Widget timeWidget(int index) {
      var outputDate = DateTime.now().toString();
      if (index < getCartHistoryList.length) {
        //That is the format that out current data is stored as. We need to use parse in order to get our data from our list and convert it to a DateTime format ?
        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss")
            .parse(getCartHistoryList[listCounter].time!);
        var inputDate = DateTime.parse(parseDate.toString());
        //This is the format that we want
        var outputFormat = DateFormat("MM/dd/yyyy hh:mm a");
        //our outputFormat takes a date time object
        outputDate = outputFormat.format(inputDate);
      }
      return LargeText(text: outputDate);
    }

    return Scaffold(
      //We did not use appBar here because we have less control over it. Instead we will design every thing inside the column
      body: Column(
        children: [
          //This is our appBar
          Container(
            height: Dimensions.height10 * 10,
            color: Colors.blue,
            width: double.maxFinite,
            padding: EdgeInsets.only(top: Dimensions.height45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LargeText(
                  text: "Cart History",
                  color: Colors.white,
                ),
                const MyIcons(
                  icon: Icons.shopping_cart_outlined,
                  iconColor: Colors.blue,
                  backgroundColor: Colors.yellow,
                )
              ],
            ),
          ),
          //Our main body
          GetBuilder<CartController>(builder: (cartController) {
            return cartController.getCartHistoryList().isNotEmpty
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: Dimensions.height20,
                          left: Dimensions.width20,
                          right: Dimensions.width20),
                      //We are using ListView instead of ListView builder because the builder version can't handle the calculations that we will do
                      //ListView compiles and run things at one time while ListViewBuilder compiles and runs things on demand
                      //We use MediaQuery to remove the padding that comes default with listView
                      child: MediaQuery.removePadding(
                          //this what atually removes the padding from ListView
                          removeTop: true,
                          context: context,
                          child: ListView(
                            children: [
                              for (int i = 0; i < itemsPerOrder.length; i++)
                                //Our main body order sections
                                Container(
                                  height: Dimensions.height10 * 12,
                                  margin: EdgeInsets.only(
                                      bottom: Dimensions.height20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      timeWidget(listCounter),
                                      SizedBox(
                                        height: Dimensions.height10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Images. Wrap makes us draw the same thing again and again in a certain direction
                                          Wrap(
                                            direction: Axis.horizontal,
                                            children: List.generate(
                                                itemsPerOrder[i], (index) {
                                              //We use this to check for overflow
                                              if (listCounter <
                                                  getCartHistoryList.length) {
                                                listCounter++;
                                              }
                                              return
                                                  //If more than 3 images the lasat one will be gone
                                                  index <= 2
                                                      ? Container(
                                                          height: Dimensions
                                                                  .height20 *
                                                              4,
                                                          width: Dimensions
                                                                  .width20 *
                                                              4,
                                                          margin: EdgeInsets.only(
                                                              right: Dimensions
                                                                      .width10 /
                                                                  2),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                      Dimensions
                                                                              .radius15 /
                                                                          2),
                                                              image: DecorationImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  image: NetworkImage(MyConstants
                                                                          .BASE_URL +
                                                                      MyConstants
                                                                          .UPLOAD_URL +
                                                                      getCartHistoryList[listCounter -
                                                                              1]
                                                                          .img!))),
                                                        )
                                                      : Container();
                                            }),
                                          ),
                                          //Info to the right of the images
                                          SizedBox(
                                            height: Dimensions.height20 * 4,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                SmallText(text: "total"),
                                                LargeText(
                                                    text:
                                                        "${itemsPerOrder[i]} Items"),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          Dimensions.width10,
                                                      vertical:
                                                          Dimensions.height10 /
                                                              2),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(Dimensions
                                                                  .radius15 /
                                                              3),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.blue)),
                                                  child: SmallText(
                                                    text: "one more",
                                                    color: Colors.blue,
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                            ],
                          )),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: const Center(
                      child: NoDataPage(
                        text: "You did not place any orders yet",
                        imgPath: "assets/images/tenor.png",
                      ),
                    ),
                  );
          })
        ],
      ),
    );
  }
}
