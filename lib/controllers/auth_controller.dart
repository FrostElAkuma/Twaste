import 'package:get/get.dart';
import 'package:twaste/models/response_model.dart';
import 'package:twaste/models/singUp_model.dart';

import '../data/repository/auth_repo.dart';

//So after we did the validation in the local validation in the signUp page we need to send the information (inside the model we did) to this controller
//And then this controller sends the information to Auth Repo which will convert the data to JSON and it will sends it to the Api Client
//And then the Api client will send it to the server for validation then we get a response :D
//We use implements GetxService so we can use repository
class AuthController extends GetxController implements GetxService {
  //We are doing this because AuthRepo has a nethoid that we will call from AuthControler
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    //Data is being loaded, which means we are talking to the server
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    late ResponseModel responseModel;
    //If it was a success server would give us 200 and a token as a response
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    //To update our front ends
    update();
    return responseModel;
  }

  void saveUserNumberAndPassword(String number, String password) {
    //We will be able to call this from our device UI whenever we need it
    authRepo.saveUserNumberAndPassword(number, password);
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  Future<ResponseModel> login(String email, String passwrod) async {
    //For debuging purposes Token for our device
    print("Getting token");
    print(authRepo.getUserToken().toString());
    //Data is being loaded, which means we are talking to the server
    _isLoading = true;
    update();
    //This will be passed to our login method in the repo which will convert the data to json
    Response response = await authRepo.login(email, passwrod);
    late ResponseModel responseModel;
    //If it was a success server would give us 200 and a token as a response
    if (response.statusCode == 200) {
      //Debugging purposes token from backend
      print("Backend token");
      authRepo.saveUserToken(response.body["token"]);
      //When we sign in and get a token we can use this token in postman for testing
      print(response.body["token"].toString());
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText!);
    }
    _isLoading = false;
    //To update our front ends
    update();
    return responseModel;
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }
}
