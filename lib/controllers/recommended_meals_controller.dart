import 'package:get/get.dart';

import '../data/repository/meals_repo.dart';
import '../data/repository/recommended_meals_repo.dart';
import '../models/meal_model.dart';

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
      //print("Got data recommedned");
      _isLoaded = true;
      //This update is more like setState() to update our UI
      update();
    } else {
      print("recommended did not work");
    }
  }
}
