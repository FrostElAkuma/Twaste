// ignore_for_file: unused_field

class Product {
  int? _totalSize;
  int? _typeID;
  int? _offset;
  late List<ProductModel> _products;
  //public field (get is like the getter method kinda like c++ when we had private objects and wanted to acces them rom outside the class)
  List<ProductModel> get products => _products;

  Product(
      {required totalSize,
      required typeId,
      required offset,
      required products}) {
    _totalSize = totalSize;
    _typeID = typeId;
    _offset = offset;
    _products = products;
  }

  Product.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _typeID = json['type_id'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = <ProductModel>[];
      json['products'].forEach((v) {
        _products.add(ProductModel.fromJson(v));
      });
    }
  }
}

class ProductModel {
  int? id;
  String? name;
  String? description;
  int? price;
  int? newPrice;
  int? remaining;
  int? stars;
  String? img;
  String? location;
  String? createdAt;
  String? updatedAt;
  int? typeId;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.newPrice,
    this.remaining,
    this.stars,
    this.img,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.typeId,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    newPrice = json['new_price'];
    remaining = json['remaining'];
    stars = json['stars'];
    img = json['img'];
    location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    typeId = json['type_id'];
  }

  //Converting object to a map or Json (cuz json is like a map)
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "new_price": newPrice,
      "remaining": remaining,
      "img": img,
      "location": location,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "typeId": typeId,
    };
  }
}
