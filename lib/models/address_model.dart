class AddressModel {
  late int? _id;
  late String _addressType;
  //It is optional because if not provided we will use the username. I might remove this any ways
  late String? _contactPersonName;
  late String? _contactPersonNumber;
  late String _address;
  late String _latitude;
  late String _longitude;

  AddressModel({
    //note tehse values do not have the underscores because they will be given to us from outside. Then we will pass them to the private vars
    id,
    required addressType,
    contactPersonName,
    contactPersonNumber,
    required address,
    required latitude,
    required longitude,
  }) {
    _id = id;
    _addressType = addressType;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
  }

  //setters and getters (since they are private) just like C++
  String get address => _address;
  String get addressType => _addressType;
  String? get contactPersonName => _contactPersonName;
  String? get contactPersonNumber => _contactPersonNumber;
  String get latitude => _latitude;
  String get longitude => _longitude;

  //We need to convert Json type to object type. Since we will be getting the data from our server as Json data.
  AddressModel.fromJson(Map<String, dynamic> json) {
    //json['id'] is like giving it the key and that key corresponds to a value so we are saving the value to _id (I think)
    _id = json['id'];
    //They might be null so we use ?? so if they are null we assign them to an empty string so they do not crash the app
    _addressType = json["address_type"] ?? "";
    _contactPersonName = json["contact_person_name"] ?? "";
    _contactPersonNumber = json["contact_person_number"] ?? "";
    _address = json["address"];
    _latitude = json["latitude"] ?? "";
    _longitude = json["longitude"] ?? "";
  }

  //Converting data to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['add_type'] = _addressType;
    data['contact_person_number'] = _contactPersonNumber;
    data['contact_person_name'] = _contactPersonName;
    data['address'] = _address;
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    return data;
  }
}
