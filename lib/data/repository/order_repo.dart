import 'package:twaste/data/api/api_client.dart';
import 'package:get/get.dart';
import 'package:twaste/utils/my_constants.dart';

class OrderRepo {
  final ApiClient apiClient;
  OrderRepo({required this.apiClient});

  //We used Getx only for the <Response>
  Future<Response> placeOrder() async {
    return await apiClient.getData(MyConstants.PLACE_ORDER_URI);
  }
}
