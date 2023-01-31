import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twaste/controllers/cart_controller.dart';
import 'package:twaste/data/repository/restaurant_repo.dart';
import 'package:twaste/models/cart_model.dart';
import 'package:twaste/models/restaurant_model.dart';

//Notice how this time we used GetxController and not GetxService like we did in our repo and api client
class RestaurantController extends GetxController {
  final RestaurantRepo restaurantRepo;
  RestaurantController({required this.restaurantRepo});

  List<dynamic> _restaurantList = [];
  //We cant call _restaurantList directly cuz it is a private variable so we use restaurantList so we can use it in our UI
  List<dynamic> get restaurantList => _restaurantList;

  //For loading icon
  bool _isLoaded = false;
  //Getter jsut like c++
  bool get isLoaded => _isLoaded;

  int _quantity = 0;
  int get quantity => _quantity;

  //So here i will call my repository and my reposiory will return the data and i will put the data inside the list
  Future<void> getRestaurantList() async {
    print("Line 27 restaurant_controller Got called !!!!!!!!!!!!");
    //We used await because getrestaurantList is returning a future type. We also saved the data inside a response object cuz the data that will be returned from getrestaurantList is Resposne type
    Response response = await restaurantRepo.getRestaurantList();
    //Status code 200 means successful
    if (response.statusCode == 200) {
      //I initialize it to NULL so my data does not get repeated
      _restaurantList = [];
      //Inside our response there is a lot of data, among which is the data we want which is json type. So in order to use it we need to convert it to model data
      //.restaurants so we get the list that is public
      _restaurantList.addAll(Restaurant.fromJson(response.body).restaurants);
      print("Line 36 restaurant_controller Got data !!!!!!!!!!!!");
      _isLoaded = true;
      //This update is more like setState() to update our UI
      update();
    } else {
      print("Line 41 Restaurant_controller DID NOT WORK");
    }
  }
}
