import 'package:twaste/models/cart_model.dart';

class PlaceOrderBody {
  List<CartModel>? _cart;
  late double _orderAmount;
  //We will use distance and orede notes a bit later
  late String _orderNote;
  late double _distance;
  late String _address;
  late String _latitude;
  late String _longitude;
  late String _contactPersonName;
  late String _contactPersonNumber;
  late String _orderType;
  late String _paymentMethod;

  PlaceOrderBody({
    required List<CartModel> cart,
    required double orderAmount,
    required double distance,
    required String scheduleAt,
    required String orderNote,
    required String address,
    required String latitude,
    required String longitude,
    required String contactPersonName,
    required String contactPersonNumber,
    required String orderType,
    required String paymentMethod,
  }) {
    _cart = cart;
    _orderAmount = orderAmount;
    _orderNote = orderNote;
    _distance = distance;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
    _orderType = orderType;
    _paymentMethod = paymentMethod;
  }

  List<CartModel> get cart => _cart!;

  double get orderAmount => _orderAmount;

  String get orderNote => _orderNote;

  double get distance => _distance;

  String get address => _address;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get contactPersonName => _contactPersonName;
  String get contactPersonNumber => _contactPersonNumber;

  PlaceOrderBody.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      _cart = [];
      json['cart'].forEach((v) {
        _cart!.add(CartModel.fromJson(v));
      });
    }

    _orderAmount = json['order_amount'];

    _orderNote = json['order_note'];

    _distance = json['distance'];

    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name'];
    _contactPersonNumber = json['contact_person_number'];
  }

  //Reminder Note whenever we sent data to server we need to send Json format. Also note the name inside the data[] is the same insdie the DB
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (_cart != null) {
      data['cart'] = _cart!.map((v) => v.toJson()).toList();
    }
    data['order_amount'] = _orderAmount;
    data['order_note'] = _orderNote;
    data['distance'] = _distance;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['contact_person_name'] = _contactPersonName;
    data['contact_person_number'] = _contactPersonNumber;
    data['order_type'] = _orderType;
    data['payment_method'] = _paymentMethod;
    return data;
  }
}
