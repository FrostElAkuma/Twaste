import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/repository/cart_reop.dart';
import '../data/repository/recommended_meals_repo.dart';
import '../models/cart_model.dart';
import '../models/meal_model.dart';

class CartController extends GetxController {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});

  //Map to save the cart items in // We will soon start using local storages instead of this cuz if we restart the app the data will be gone cuz this stored in memory
  Map<int, CartModel> _items = {};
  //getter so we can acces the list outside this class
  Map<int, CartModel> get items => _items;

  //Only for storage and shared preferences
  List<CartModel> storageItems = [];

  List<int> remaining = [];

  //This will be called when you press the add to cart button
  void addItem(ProductModel product, int quantity) {
    var totalQuantity = 0;
    //Check if a certain item is already there. If yes then update the values
    //Not sure if I should Add checking for the remaining items left in the controller as well. For now I have on the page itself.
    if (_items.containsKey(product.id!)) {
      _items.update(product.id!, (value) {
        //value.quantity is the value for the old object
        totalQuantity = value.quantity! + quantity;

        if (totalQuantity > product.remaining!) {
          Get.snackbar("Item count", "You can't add more to your cart!",
              backgroundColor: Colors.red, colorText: Colors.white);
          return CartModel(
            id: value.id,
            name: value.name,
            price: value.price,
            img: value.img,
            quantity: value.quantity!,
            remaining: value.remaining,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
          );
        } else {
          return CartModel(
            id: value.id,
            name: value.name,
            price: value.price,
            img: value.img,
            quantity: value.quantity! + quantity,
            remaining: value.remaining,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
          );
        }
      });
      //If the total quantoty is 0 we remove it from our list
      if (totalQuantity <= 0) {
        _items.remove(product.id);
      }
    } else {
      //Check if a certain key has been inserted already in the map. If not it will go ahead and insert that object or what ever you are passing
      if (quantity > 0) {
        _items.putIfAbsent(product.id!, () {
          //print("adding item to the cart " +product.id.toString() +" quantity " + quantity.toString());
          return CartModel(
            id: product.id,
            name: product.name,
            price: product.price,
            img: product.img,
            quantity: quantity,
            remaining: product.remaining,
            isExist: true,
            time: DateTime.now().toString(),
            product: product,
          );
        });
      } else {
        //messsage
        Get.snackbar("Item count", "At leat 1 item should be added",
            backgroundColor: Colors.blue, colorText: Colors.white);
      }
    }
    cartRepo.addToCartList(getItems);
    update();
  }

  Future<bool> removeItem(ProductModel product) async {
    _items.remove(product.id);
    cartRepo.addToCartList(getItems);

    return true;

    /*if (_items.length == 0) {
      if (product.remaining! <= 0) {
        Get.snackbar(
            "Item count", "Product ${product.name} is no longer available",
            backgroundColor: Colors.yellow, colorText: Colors.white);
        _items.remove(product.id);
      }
    } else {
      /*Get.snackbar(
          "Item count", "Product ${product.name} is no longer available",
          backgroundColor: Colors.yellow, colorText: Colors.white);*/
      _items.remove(product.id);
    }*/
  }

  bool existInCart(ProductModel product) {
    if (_items.containsKey(product.id)) {
      return true;
    }

    return false;
  }

  //This function so when you press on an item it shows how many you already ahve in cart
  int getQuantity(ProductModel product) {
    var quantity = 0;
    if (_items.containsKey(product.id)) {
      _items.forEach((key, value) {
        if (key == product.id) {
          quantity = value.quantity!;
        }
      });
    }
    return quantity;
  }

  //This to get the items remaining for that certain Item. This is an important function since after every confirmed order it changes. Might need to change it later for a more effiecient one
  //It was a void function but then I made it into a bool so I can use the await function when some one clicks his cart to await for the remaining items to update and then show him his cart
  Future<bool> getRemaining() async {
    List<dynamic> rem = [];
    List<dynamic> ids = [];

    _items.forEach((key, value) {
      ids.add(value.id!);
      //print("I am here line 125 " + value.id.toString());
      //print("we are here line 126 " + ids.toString());
    });

    Response response = await cartRepo.getCartRemaining(ids);
    //Status code 200 means successful
    if (response.statusCode == 200) {
      //print("we are here line 130 carController");
      rem.addAll(Product.fromJson(response.body).products);
      //print("we are hereerereerr " + rem.length.toString());
      for (int i = 0; i < rem.length; i++) {
        _items.forEach((key, value) {
          if (key == rem[i].id) {
            //print("This is old rem" + value.remaining.toString());
            //print("this is new rem" + rem[i].remaining.toString());
            value.remaining = rem[i].remaining;
            if (value.quantity! > value.remaining!) {
              value.quantity = value.remaining;
            }
          }
        });
      }
      return true;
    }
    return false;
  }

  //this is a getter so it is not a function and does not need () //We will use this to showtotal items in cart
  int get totalItems {
    var totalQuantity = 0;

    _items.forEach((key, value) {
      totalQuantity += value.quantity!;
    });

    return totalQuantity;
  }

  //Here we saying that we will return a list of CartModel
  List<CartModel> get getItems {
    //this .entries is new for me. e is like i (index)
    //first return is for the get. Second return is for the map
    return _items.entries.map((e) {
      return e.value;
    }).toList();
  }

  //total amount of moeny for all meals in cart
  int get totalAmount {
    var total = 0;
    _items.forEach((key, value) {
      total += value.price! * value.quantity!;
    });
    return total;
  }

  //This will only get called when the user starts the app
  List<CartModel> getCartData() {
    setCart = cartRepo.getCartlist();
    getRemaining();
    return storageItems;
  }

  //set just like c++ ? With set we have to accept something in our parameters
  set setCart(List<CartModel> items) {
    storageItems = items;
    //print("Length of cart items " + storageItems.length.toString());

    for (int i = 0; i < storageItems.length; i++) {
      //If the key is absent (product.id) we add that list to our _items
      //When we will call this _items will be empty since the user just started the app
      _items.putIfAbsent(storageItems[i].product!.id!, () => storageItems[i]);
    }
  }

  //When the checkout button is pressed we call this function
  void addToHistory() {
    cartRepo.addToCartHistoryList();
    clear();
  }

  void clear() {
    _items = {};
    //So we redraw our cart after clearing items
    update();
  }

  //Clear for remove only diffirence from the above clear is that this one is without update
  void clearRemove() {
    _items = {};
  }

  List<CartModel> getCartHistoryList() {
    return cartRepo.getCartHistoryList();
  }

  void clearCartHistory() {
    cartRepo.clearCartHistory();
    update();
  }

  void removeCartSharedPreference() {
    cartRepo.removeCartSharedPreference();
  }
}
