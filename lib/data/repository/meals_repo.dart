import 'package:get/get.dart';
import 'package:twaste/data/api/api_client.dart';
import 'package:twaste/utils/my_constants.dart';

//Repositories talk to Api client and it has to do with internet connection ? And that is why when we load data from the internet we should extend the GetxService ?
class MealRepo extends GetxService {
  //So by declaring the ApiClient variable now our repo and ApiClient are connected and we can call any methods that is in our ApiClient insidide this repo
  final ApiClient apiClient;

  MealRepo({required this.apiClient});

  Future<Response> getMealList() async {
    return await apiClient.getData(MyConstants
        .POPULAR_PRODUCT_URI); // I will get the correct uri in the second video
  }
}
