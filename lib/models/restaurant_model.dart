class Restaurant {
  int? _totalSize;
  //int? _typeID;
  //int? _offset;
  late List<RestaurantModel> _restaurants;
  //public field (get is like the getter method kinda like c++ when we had private objects and wanted to acces them rom outside the class)
  List<RestaurantModel> get restaurants => _restaurants;

  //Constructor
  Restaurant(
      {required totalSize,
      //required typeId,
      //required offset,
      required restaurants}) {
    this._totalSize = totalSize;
    //this._typeID = typeId;
    //this._offset = offset;
    this._restaurants = restaurants;
  }

  Restaurant.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    //_typeID = json['type_id'];
    //_offset = json['offset'];
    if (json['restaurants'] != null) {
      _restaurants = <RestaurantModel>[];
      json['restaurants'].forEach((v) {
        _restaurants.add(RestaurantModel.fromJson(v));
      });
    }
  }
}

//Constructor
class RestaurantModel {
  int? id;
  String? name;
  //String? description;
  //int? price;
  //int? stars;
  //String? img;
  //String? location;
  String? createdAt;
  String? updatedAt;
  //int? typeId;

  RestaurantModel({
    this.id,
    this.name,
    //this.description,
    //this.price,
    //this.stars,
    //this.img,
    //this.location,
    this.createdAt,
    this.updatedAt,
    //this.typeId,
  });

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    //description = json['description'];
    //price = json['price'];
    //stars = json['stars'];
    //img = json['img'];
    //location = json['location'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    //typeId = json['type_id'];
  }

  //Converting object to a map or Json (cuz json is like a map)
  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      //"price": this.price,
      //"img": this.img,
      //"location": this.location,
      "createdAt": this.createdAt,
      "updatedAt": this.updatedAt,
      //"typeId": this.typeId,
    };
  }
}
