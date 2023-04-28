import 'package:get/get.dart';

import '../data/repository/meals_repo.dart';
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
  //int get incCartItems => _inCartItems + _quantity;

  //This for editing button
  bool _editing = false;
  bool get editing => _editing;

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
      //print("we are here line 48 recoController" + _quantity.toString());
      //print("Got data recommedned");
      _isLoaded = true;
      //This update is more like setState() to update our UI
      update();
    } else {
      print("recommended did not work");
    }
  }

  //Adding and subtracting items
  void setQuantity(bool isIncrement, index) {
    var quantit = _quantity[index];
    if (isIncrement) {
      print("increment" + quantit.toString());
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
    /*exist = _cart.existInCart(product);
    if (exist) {
      _inCartItems = _cart.getQuantity(product);
    }*/
  }

  //To add to cart
  void addItem(ProductModel product, index) {
    _cart.addItem(product, _quantity[index]);
    //Before adding should be 0 and after adding should also be reset to 0
    _quantity[index] = 0;

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

  //Security Concern Here. Need to add validation here to make sure it is the vendor of the restaurant0
  void isEditing() {
    if (_editing) {
      _editing = false;
    } else {
      _editing = true;
    }
    print(_editing);
    update();
  }
}
