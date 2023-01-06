import 'package:get/get.dart';
import 'package:twaste/data/repository/order_repo.dart';

//We use GetxService So we can use the OrderController thro out our app and not be restricted to a certain page
class OrderController extends GetxController implements GetxService {
  OrderRepo orderRepo;

  OrderController({required this.orderRepo});
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> placeOrder(Function callback) async {
    _isLoading = true;
    Response response = await orderRepo.placeOrder();
    if (response.statusCode == 200) {
      _isLoading = false;
      String message = response.body['message'];
      String orderId = response.body['order_id'].toString();
      callback(true, message, orderId);
    } else {
      callback(false, response.statusText, '-1');
    }
  }
}
