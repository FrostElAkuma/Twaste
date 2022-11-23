import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/cart_controller.dart';
import 'package:twaste/models/cart_model.dart';

import '../data/repository/meals_repo.dart';
import '../models/meal_model.dart';

//Notice how this time we used GetxController and not GetxService like we did in our repo and api client
class MealController extends GetxController {
  final MealRepo mealRepo;
  MealController({required this.mealRepo});

  List<dynamic> _mealList = [];
  //We cant call _mealList directly cuz it is a private variable so we use mealList so we can use it in our UI
  List<dynamic> get mealList => _mealList;

  //For our cart
  late CartController _cart;

  //For loading icon
  bool _isLoaded = false;
  //Getter jsut like c++
  bool get isLoaded => _isLoaded;

  int _quantity = 0;
  int get quantity => _quantity;
  int _inCartItems = 0;
  int get incCartItems => _inCartItems + _quantity;

  //So here i will call my repository and my reposiory will return the data and i will put the data inside the list
  Future<void> getMealList() async {
    //We used await because getMealList is returning a future type. We also saved the data inside a response object cuz the data that will be returned from getMealList is Resposne type
    Response response = await mealRepo.getMealList();
    //Status code 200 means successful
    if (response.statusCode == 200) {
      //I initialize it to NULL so my data does not get repeated
      _mealList = [];
      //Inside our response there is a lot of data, among which is the data we want which is json type. So in order to use it we need to convert it to model data
      //.products so we get the list that is public
      _mealList.addAll(Product.fromJson(response.body).products);
      //print("Got data");
      _isLoaded = true;
      //This update is more like setState() to update our UI
      update();
    } else {
      print("didnotwork");
    }
  }

  //Adding and subtracting items
  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      //print("increment" + _quantity.toString());
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
    }
    //So values inside our page upfate real time. This upfate is built in Getx managment package :D !
    update();
  }

  int checkQuantity(int quantity) {
    if ((_inCartItems + quantity) < 0) {
      //This is like a msg hat we can show the user that is built in Getx but i dont need it now
      //Get.snackbar("Item count", "You can't reduce more!", backgroundColor: Colors.blue, colorText: Colors.white);
      //11:10:00
      if (_inCartItems > 0) {
        _quantity = -_inCartItems;
        return quantity;
      }
      return 0;
      //20 is like a limit of 20 orderes. later we can have the max ammount come from the server
    } else if ((_inCartItems + quantity) > 20) {
      return 20;
    } else {
      return quantity;
    }
  }

  void initProduct(ProductModel product, CartController cart) {
    _quantity = 0;
    _inCartItems = 0;
    _cart = cart;
    var exist = false;
    exist = _cart.existInCart(product);
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
    }
  }

  //To add to cart
  void addItem(ProductModel product) {
    _cart.addItem(product, _quantity);
    //Before adding should be 0 and after adding should also be reset to 0
    _quantity = 0;

    ///We need this else when we minus an item it will be 0 instantly
    _inCartItems = _cart.getQuantity(product);
    _cart.items.forEach((key, value) {
      print("The id is " +
          value.id.toString() +
          " The quantity is " +
          value.quantity.toString());
    });
    update();
  }

  //getting total items to show in cart
  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems {
    return _cart.getItems;
  }
}
