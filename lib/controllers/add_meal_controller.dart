import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twaste/data/repository/add_meal_repo.dart';
import 'package:http/http.dart' as http;

class AddMealController extends GetxController {
  //AddMealRepo addMealRepo;

  //AddMealController({required this.addMealRepo});
  PickedFile? _pickedFile;
  PickedFile? get pickedFile => _pickedFile;

  String? _imagePath;
  String? get imagePath => _imagePath;

  final _picker = ImagePicker();

  //image picker
  Future<void> pickImage() async {
    //Accessing the gallery
    _pickedFile = await _picker.getImage(source: ImageSource.gallery);
    update();
  }

  Future<bool> upload() async {
    update();
    bool success = false;
    http.StreamedResponse response = await updateImage(_pickedFile);
    //_isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String message = map["message"];
      _imagePath = message;
      // _pickedFile = null;
      //await getUserInfo();
      success = true;
      print(message);
    } else {
      print("error posting the image");
    }
    update();
    return success;
  }

  Future<http.StreamedResponse> updateImage(PickedFile? data) async {
    http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://cd23-86-98-115-176.in.ngrok.io/api/v1/restaurant/upload'));
    // request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if (GetPlatform.isMobile && data != null) {
      File _file = File(data.path);
      request.files.add(http.MultipartFile(
          'image', _file.readAsBytes().asStream(), _file.lengthSync(),
          filename: _file.path.split('/').last));
    }
    /*Map<String, String> _fields = Map();
    _fields.addAll(<String, String>{
      'f_name': userInfoModel.fName,
      'email': userInfoModel.email
    });*/
    //request.fields.addAll(_fields);
    http.StreamedResponse response = await request.send();
    return response;
  }
}
