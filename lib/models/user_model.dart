class UserModel {
  int id;
  int? vendor_id;
  //In Db it is f_name
  String name;
  String email;
  String phone;
  int orderCount;

  UserModel({
    required this.id,
    this.vendor_id,
    required this.name,
    required this.email,
    required this.phone,
    required this.orderCount,
  });

  //This wouldbe a get request from DB so we need to create a controller and a repo
  //Map<> is the data type and the object name is json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    //We are getting json data from DB so we need to comvert it to object
    return UserModel(
        id: json['id'],
        vendor_id: json['vendor_id'],
        name: json[
            'f_name'], //field need to match name in DB that is why we sued f_name
        email: json['email'],
        phone: json['phone'],
        orderCount: json['order_count']);
  }
}
