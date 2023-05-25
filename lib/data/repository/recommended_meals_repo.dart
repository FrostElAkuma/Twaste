import 'package:get/get.dart';
import 'package:twaste/data/api/api_client.dart';
import 'package:twaste/utils/my_constants.dart';

//Repositories talk to Api client and it has to do with internet connection ? And that is why when we load data from the internet we should extend the GetxService ?
class RecommendedMealRepo extends GetxService {
  //So by declaring the ApiClient variable now our repo and ApiClient are connected and we can call any methods that is in our ApiClient insidide this repo
  final ApiClient apiClient;

  RecommendedMealRepo({required this.apiClient});

  Future<Response> getRecommendedMealList(String restaurantID) async {
    return await apiClient.getData(
        '${MyConstants.RECOMMENDED_PRODUCT_URI}?restaurantid=$restaurantID');
  }

  Future<Response> updateRemaining(String mealID, String rem) async {
    return await apiClient.postData(
        MyConstants.UPDATE_REMAINING_URI, {"id": mealID, "remaining": rem});
  }

  Future<Response> removeItem(String mealID) async {
    return await apiClient
        .postData(MyConstants.REMOVE_ITEM_URI, {"id": mealID});
  }
}
