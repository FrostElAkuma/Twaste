//Repos get or store data

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:twaste/utils/my_constants.dart';

import '../../models/cart_model.dart';

class CartRepo {
  final SharedPreferences sharedPreferences;
  //shared preferences store data in string format
  CartRepo({required this.sharedPreferences});

  List<String> cart = [];
  List<String> cartHistory = [];

  //we want to take the cartList and save it to our shared preferences
  //From object to string
  //VIP when you want to save data to server or save data to storage we either save them as Json format or string object
  //VIP server will probably send object so we will have to decode it ? . If it sends json we encode it then save it
  void addToCartList(List<CartModel> cartList) {
    //sharedPreferences.remove(MyConstants.CART_LIST); //used this for debugging purposes to clear all orders
    //sharedPreferences.remove(MyConstants.CART_HISTORY_LIST); // used this for debugging purposses
    var time = DateTime.now().toString();
    cart = [];
    cartList.forEach((element) {
      element.time = time;
      //jsonEncode cast our element from Object to Json or string! sharedpreferences only accepts string
      return cart.add(jsonEncode(element));
    });
    //adding our cart list to our sharedPreferences
    sharedPreferences.setStringList(MyConstants.CART_LIST, cart);
    //print(sharedPreferences.getStringList(MyConstants.CART_LIST));
  }

  //From string to object
  List<CartModel> getCartlist() {
    List<String> carts = [];
    //check if key exists or not
    if (sharedPreferences.containsKey(MyConstants.CART_LIST)) {
      //save the information inside our string list
      carts = sharedPreferences.getStringList(MyConstants.CART_LIST)!;
      //print("Inside getCartList" + carts.toString());
    }
    List<CartModel> cartList = [];

    //So now our info i saved as string and this function returns an object of CartModel so we need to do that
    carts.forEach((element) {
      //fromJson takes a map as an argument. Flutter has a built in method jsonDecode which can change out string elements to a map
      cartList.add(CartModel.fromJson(jsonDecode(element)));
    });

    return cartList;
  }

  List<CartModel> getCartHistoryList() {
    if (sharedPreferences.containsKey(MyConstants.CART_HISTORY_LIST)) {
      cartHistory = [];
      cartHistory =
          sharedPreferences.getStringList(MyConstants.CART_HISTORY_LIST)!;
    }
    //we need to return an object and not a string
    List<CartModel> cartListHistory = [];
    cartHistory.forEach((element) =>
        cartListHistory.add(CartModel.fromJson(jsonDecode(element))));
    return cartListHistory;
  }

  void addToCartHistoryList() {
    //so if there are previous items in cart history we do not lose them. We add them and then add the new oens
    if (sharedPreferences.containsKey(MyConstants.CART_HISTORY_LIST)) {
      cartHistory =
          sharedPreferences.getStringList(MyConstants.CART_HISTORY_LIST)!;
    }
    for (int i = 0; i < cart.length; i++) {
      //print("history list " + cart[i]);
      cartHistory.add(cart[i]);
    }
    cart = [];
    sharedPreferences.setStringList(MyConstants.CART_HISTORY_LIST, cartHistory);

    /*print("the length of history list is " +
        getCartHistoryList().length.toString());*/

    /*for (int j = 0; j < getCartHistoryList().length; j++) {
      print("the time for the order is " +
          getCartHistoryList()[j].time.toString());
    }*/
  }

  void removeCart() {
    cart = [];
    sharedPreferences.remove(MyConstants.CART_LIST);
  }

  void clearCartHistory() {
    removeCart();
    cartHistory = [];
    sharedPreferences.remove(MyConstants.CART_HISTORY_LIST);
  }

  void removeCartSharedPreference() {
    sharedPreferences.remove(MyConstants.CART_LIST);
    sharedPreferences.remove(MyConstants.CART_HISTORY_LIST);
  }
}
