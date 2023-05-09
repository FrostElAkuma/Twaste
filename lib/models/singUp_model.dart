class SignUpBody {
  String name;
  String phone;
  String email;
  String password;
  SignUpBody({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    //Note Map and Json are the same in flutter
    final Map<String, dynamic> data = <String, dynamic>{};
    data["f_name"] = name;
    data["phone"] = phone;
    data["email"] = email;
    data["password"] = password;

    return data;
  }
}
