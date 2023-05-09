import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/repository/recommended_meals_repo.dart';
import '../models/cart_model.dart';
import '../models/meal_model.dart';
import 'cart_controller.dart';

//Notice how this time we used GetxController and not GetxService like we did in our repo and api client
class RecommendedMealController extends GetxController {
  final RecommendedMealRepo recommendedMealRepo;
  RecommendedMealController({required this.recommendedMealRepo});

  List<dynamic> _recommendedMealList = [];
  //We cant call _mealList directly cuz it is a private variable so we use mealList so we can use it in our UI
  List<dynamic> get recommendedMealList => _recommendedMealList;

  //For loading icon
  bool _isLoaded = false;
  //Getter jsut like c++
  bool get isLoaded => _isLoaded;

  //For our cart
  late CartController _cart;

  List<dynamic> _quantity = [0];
  //int _quantity = 0;
  List get quantity => _quantity;
  int _inCartItems = 0;
  final int _remainigItems = 0;
  //int get incCartItems => _inCartItems + _quantity;

  //This for meals remaning
  List<dynamic> _remaining = [0];
  List get remaining => _remaining;

  //This for editing button
  bool _editing = false;
  bool get editing => _editing;

  //This to check if a change was made
  List<dynamic> _originalRemaining = [];

  //Full meals list even with 0 meals
  final List<dynamic> _OriginalRecommendedMealList = [];
  List<dynamic> get OriginalRecommendedMealList => _OriginalRecommendedMealList;

  //So here i will call my repository and my reposiory will return the data and i will put the data inside the list
  Future<void> getRecommendedMealList(int restId) async {
    //We used await because getMealList is returning a future type. We also saved the data inside a response object cuz the data that will be returned from getMealList is Resposne type
    //I have 2 options either I get the restaurant ID and egt the meals of only that restaurant OR get all the meals and when presse on a restaurant I filter that huge list based on restaurant ID. I think the first option is more effecient.
    String restIdString = restId.toString();
    Response response =
        await recommendedMealRepo.getRecommendedMealList(restIdString);
    //Status code 200 means successful
    if (response.statusCode == 200) {
      //I initialize it to NULL so my data does not get repeated
      _recommendedMealList = [];
      //Inside our response there is a lot of data, among which is the data we want which is json type. So in order to use it we need to convert it to model data
      //.products so we get the list that is public
      _recommendedMealList.addAll(Product.fromJson(response.body).products);
      var recoLength = _recommendedMealList.length;
      _quantity = List<int>.filled(recoLength, 0, growable: true);
      _remaining = List<int>.filled(recoLength, 0, growable: true);
      _originalRemaining = List<int>.filled(recoLength, 0, growable: true);
      //Not a big fan of this while loop but guess it does the job for now
      var i = 0;
      while (i < recoLength) {
        _remaining[i] = _recommendedMealList[i].remaining;
        _originalRemaining[i] = _recommendedMealList[i].remaining;
        i++;
      }
      //_originalRemaining = _remaining;
      //print("We are here recoMealController line 73" + _remaining.toString());
      //print("we are here line 48 recoController" + _quantity.toString());
      //print("Got data recommedned");
      _isLoaded = true;
      //This update is more like setState() to update our UI
      update();
    } else {
      print("recommended did not work");
    }
  }

  //Adding and subtracting items for cart
  void setQuantity(bool isIncrement, index) {
    var quantit = _quantity[index];
    if (isIncrement) {
      print("increment$quantit");
      _quantity[index] = checkQuantity(quantit + 1, index);
    } else {
      _quantity[index] = checkQuantity(quantit - 1, index);
    }
    //So values inside our page upfate real time. This upfate is built in Getx managment package :D !
    update();
  }

  int checkQuantity(int quantity, index) {
    if ((_inCartItems + quantity) < 0) {
      //This is like a msg hat we can show the user that is built in Getx but i dont need it now
      //Get.snackbar("Item count", "You can't reduce more!", backgroundColor: Colors.blue, colorText: Colors.white);
      //11:10:00
      if (_inCartItems > 0) {
        _quantity[index] = -_inCartItems;
        return quantity;
      }
      return 0;
      //20 is like a limit of 20 orderes. later we can have the max ammount come from the server
    } else if ((_inCartItems + quantity) >
        _recommendedMealList[index].remaining) {
      return _recommendedMealList[index].remaining;
    } else {
      return quantity;
    }
  }

  void initProduct(CartController cart) {
    var recoLength = _recommendedMealList.length;
    _quantity = List<int>.filled(recoLength, 0, growable: true);
    _inCartItems = 0;
    _cart = cart;
    var exist = false;
    //This to show how much of that certain item you have in caart. You can have it or leave it
    /*exist = _cart.existInCart(product);
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
    }*/
  }

  //To add to cart
  void addItem(ProductModel product, index) {
    if ((_cart.getQuantity(product) + _quantity[index]) > product.remaining!) {
      Get.snackbar("Item count", "You can't add more to your cart!",
          backgroundColor: Colors.red, colorText: Colors.white);
    } else {
      _cart.addItem(product, _quantity[index]);
      //Before adding should be 0 and after adding should also be reset to 0
      _quantity[index] = 0;
    }

    //We need this else when we minus an item it will be 0 instantly
    //This If I am showing items currently in cart inside the restaurant page
    /*_inCartItems = _cart.getQuantity(product);
    _cart.items.forEach((key, value) {
      print("The id is " +
          value.id.toString() +
          " The quantity is " +
          value.quantity.toString());
    });*/
    update();
  }

  //getting total items to show in cart
  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems {
    return _cart.getItems;
  }

  //Security Concern Here. Need to add validation here to make sure it is the vendor of the restaurant0
  void isEditing(int restId) {
    //Done editing
    if (_editing) {
      _editing = false;
      /*print("We are here recoMealController line 163" + _remaining.toString());
      print("We are here recoMealController line 164" +
          _originalRemaining.toString());*/
      //To check if there was a change in the original list, if there wasn't no need to send a request to our backend
      if (listEquals(_remaining, _originalRemaining) == true) {
        //print("Line 165 recoMealController no change was made to the ramining list");
      } else {
        //Again not a fan of this while loop but it shall do the job for now
        var recoLength = _recommendedMealList.length;
        var i = 0;
        //updating our original list with the new remaining items
        while (i < recoLength) {
          if (_remaining[i] == _originalRemaining[i]) {
            //print("Line 167 recoMealController no change was made to this item" + _recommendedMealList[i].id.toString());
          } else {
            _recommendedMealList[i].remaining = _remaining[i];
            //Sending post req. to server. Need more security on this to make sure that the vendor is updateing his meals and not other vendor's meals
            //Think what is better is to send 1 request with all the meal Ids that need changing instead of sending a request for each one but guess wil do this later
            recommendedMealRepo.updateRemaining(
                _recommendedMealList[i].id.toString(),
                _recommendedMealList[i].remaining.toString());
          }
          i++;
        }
      }
    }
    //Started editing
    else {
      _editing = true;
    }
    //print(_editing);
    update();
  }

  //Adding and subtracting items for remaining. I know I am repeating the Code this needs optimizing later as well
  void setQuantityRemaining(bool isIncrement, index) {
    var quantit = _remaining[index];
    if (isIncrement) {
      /*print("increment " + quantit.toString());
      print("We are here recoMealController line 175" + _remaining.toString());*/
      _remaining[index] = checkQuantityRemaining(quantit + 1, index);
    } else {
      _remaining[index] = checkQuantityRemaining(quantit - 1, index);
    }
    //So values inside our page upfate real time. This upfate is built in Getx managment package :D !
    update();
  }

  int checkQuantityRemaining(int quantity, index) {
    if ((_remainigItems + quantity) < 0) {
      //This is like a msg hat we can show the user that is built in Getx but i dont need it now
      //Get.snackbar("Item count", "You can't reduce more!", backgroundColor: Colors.blue, colorText: Colors.white);
      //11:10:00
      if (_remainigItems > 0) {
        _remaining[index] = -_remainigItems;
        return quantity;
      }
      return 0;
      //20 is like a limit of 20 orderes. later we can have the max ammount come from the server
    } else if ((_remainigItems + quantity) > 50) {
      return 50;
    } else {
      return quantity;
    }
  }
}
