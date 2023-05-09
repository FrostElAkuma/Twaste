import 'package:twaste/models/meal_model.dart';

class CartModel {
  int? id;
  String? name;
  //String? description;
  int? price;
  //int? stars;
  String? img;
  //String? location;
  //String? createdAt;
  //String? updatedAt;
  //int? typeId;
  int? quantity;
  int? remaining;
  bool? isExist; //If it was added in the cart or not
  String? time; //time it was added
  ProductModel? product;

  CartModel({
    this.id,
    this.name,
    //this.description,
    this.price,
    //this.stars,
    this.img,
    //this.location,
    //this.createdAt,
    //this.updatedAt,
    //this.typeId,
    this.quantity,
    this.remaining,
    this.isExist,
    this.time,
    this.product,
  });
  //From JSOn to Object
  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    //description = json['description'];
    price = json['price'];
    //stars = json['stars'];
    img = json['img'];
    //location = json['location'];
    //createdAt = json['created_at'];
    //updatedAt = json['updated_at'];
    //typeId = json['type_id'];
    quantity = json['quantity'];
    remaining = json['remaining'];
    isExist = json['isExist'];
    time = json['time'];
    product = ProductModel.fromJson(json['product']); //25:00
  }

  //From object to Json (we are returning a map which is like json ?) key is String and value is dynamic
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "img": img,
      "quantity": quantity,
      "remaining": remaining,
      "isExist": isExist,
      "time": time,
      //Product we did a function for this in out meal_model
      "product": product!.toJson(),
    };
  }
}
