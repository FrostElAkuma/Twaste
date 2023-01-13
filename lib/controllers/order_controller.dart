import 'package:get/get.dart';
import 'package:twaste/data/api/api_checker.dart';
import 'package:twaste/data/repository/order_repo.dart';
import 'package:twaste/models/order_model.dart';

import '../models/place_order_model.dart';

//We use GetxService So we can use the OrderController thro out our app and not be restricted to a certain page
class OrderController extends GetxController implements GetxService {
  OrderRepo orderRepo;

  OrderController({required this.orderRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late List<OrderModel> _currentOrderList;
  List<OrderModel> get currentOrderList => _currentOrderList;

  late List<OrderModel> _historyOrderList;
  List<OrderModel> get historyOrderList => _historyOrderList;

  Future<void> placeOrder(PlaceOrderBody placeOrder, Function callback) async {
    _isLoading = true;
    Response response = await orderRepo.placeOrder(placeOrder);
    if (response.statusCode == 200) {
      _isLoading = false;
      String message = response.body['message'];
      String orderId = response.body['order_id'].toString();
      callback(true, message, orderId);
    } else {
      callback(false, response.statusText, '-1');
    }
  }

  Future<void> getOrderList() async {
    _isLoading = true;
    Response response = await orderRepo.getOrderList();
    //VIP it is highly recommended whenver we get data from server to convert it from Json to object. In order to do that we need to make a model.
    if (response.statusCode == 200) {
      _historyOrderList = [];
      _currentOrderList = [];
      response.body.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        //Any of these means the order is running
        if (orderModel.orderStatus == 'pending' ||
            orderModel.orderStatus == 'accepted' ||
            orderModel.orderStatus == 'processing' ||
            orderModel.orderStatus == 'handover' ||
            orderModel.orderStatus == 'picked_up') {
          _currentOrderList.add(orderModel);
        } else {
          _historyOrderList.add(orderModel);
        }
      });
    } else {
      _historyOrderList = [];
      _currentOrderList = [];
    }
    _isLoading = false;
    //print("The length of the orders" + _currentOrderList.length.toString());
    ///print("The length of the orders" + _historyOrderList.length.toString());
    update();
  }
}
