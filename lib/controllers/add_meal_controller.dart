import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twaste/data/repository/add_meal_repo.dart';
import 'package:http/http.dart' as http;
import 'package:twaste/models/meal_model.dart';
import 'package:twaste/utils/my_constants.dart';

import '../models/response_model.dart';

class AddMealController extends GetxController {
  final AddMealRepo addMealRepo;

  AddMealController({required this.addMealRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
      print('I am here line 48 addMealcontroller $message');
    } else {
      print("error posting the image");
    }
    update();
    return success;
  }

  Future<http.StreamedResponse> updateImage(PickedFile? data) async {
    http.MultipartRequest request = http.MultipartRequest('POST',
        Uri.parse(MyConstants.BASE_URL + MyConstants.MEAL_IMAGE_UPLOAD_URI));
    // request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
    if (GetPlatform.isMobile && data != null) {
      File file = File(data.path);
      request.files.add(http.MultipartFile(
          'image', file.readAsBytes().asStream(), file.lengthSync(),
          filename: file.path.split('/').last));
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

  Future<ResponseModel> addMeal(String name, int price) async {
    //Data is being loaded, which means we are talking to the server
    bool imgGood = await upload();
    late ResponseModel responseModel;
    if (imgGood) {
      ProductModel productModel = ProductModel(
        name: name,
        price: price,
        img: imagePath,
      );

      _isLoading = true;
      update();
      Response response = await addMealRepo.addMeal(productModel);

      //If it was a success server would give us 200
      if (response.statusCode == 200) {
        print("Line 84 add_meal_controller -> meal added to DB");
        responseModel = ResponseModel(true, response.body);
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
      _isLoading = false;
      //To update our front ends
      update();
      return responseModel;
    } else {
      responseModel = ResponseModel(false, "failed to get image");
      return responseModel;
    }
  }
}
