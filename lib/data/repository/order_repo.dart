import 'package:twaste/data/api/api_client.dart';
import 'package:get/get.dart';
import 'package:twaste/models/place_order_model.dart';
import 'package:twaste/utils/my_constants.dart';

class OrderRepo {
  final ApiClient apiClient;
  OrderRepo({required this.apiClient});

  //We used Getx only for the <Response>
  Future<Response> placeOrder(PlaceOrderBody placeOrder) async {
    //Note: postData for posting info and we can only send Json format
    return await apiClient.postData(
        MyConstants.PLACE_ORDER_URI, placeOrder.toJson());
  }

  //Note again: This is Get method so no need to pass any thing unlike above post method
  Future<Response> getOrderList() async {
    return await apiClient.getData(MyConstants.ORDER_LIST_URI);
  }
}
