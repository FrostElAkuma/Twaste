import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:twaste/models/user_model.dart';

import '../data/repository/user_repo.dart';
import '../models/response_model.dart';

class UserController extends GetxController implements GetxService {
  //We are doing this because AuthRepo has a method that we will call from AuthControler
  final UserRepo userRepo;
  UserController({required this.userRepo});

  bool _isLoading = false;
  UserModel? _userModel;
  bool get isLoading => _isLoading;
  // We are gomma save the user information inside userModel and Using a getter so we can use it in our UI.
  UserModel? get userModel => _userModel;

  Future<ResponseModel> getUserInfo() async {
    _isLoading = true;
    //print("I am here");
    Response response = await userRepo.getUserInfo();
    late ResponseModel responseModel;
    print("this is the response ${response.body}");
    //If it was a success server would give us 200 and a token as a response
    if (response.statusCode == 200) {
      _userModel = UserModel.fromJson(response.body);

      responseModel = ResponseModel(true, "successful");
    } else {
      responseModel = ResponseModel(false, response.statusText!);
      print(response.statusText);
    }
    //To update our front ends
    _isLoading = false;
    update();
    return responseModel;
  }
}
