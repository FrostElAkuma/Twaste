import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twaste/models/singUp_model.dart';
import 'package:twaste/utils/my_constants.dart';

import '../api/api_client.dart';

//Don't forget to add the contollers and Repos to our independencies
class AuthRepo {
  final ApiClient apiClient;
  //This so when we get the token from the server we save it insode our app
  final SharedPreferences sharedPreferences;
  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> registration(SignUpBody signUpBody) async {
    //The uri is the endpoint that we defined on our constants
    //Note teh body data here needs to be JSON, We convert the data to JSON in our sign_up model
    return await apiClient.postData(
        MyConstants.REGISTRATION_URI, signUpBody.toJson());
  }

  bool userLoggedIn() {
    //We used .contains key here cuz it returns bool
    //I added this line for debugging
    print("Getting token now " +
        sharedPreferences.getString(MyConstants.TOKEN).toString());
    return sharedPreferences.containsKey(MyConstants.TOKEN);
  }

  Future<String> getUserToken() async {
    //If it does not exist return None
    return await sharedPreferences.getString(MyConstants.TOKEN) ?? "None";
  }

  Future<Response> login(String phone, String password) async {
    return await apiClient.postData(
        //The "email":email is json format but since they are only 2 fields we wrote them manually and did not do like we did with signUpBody
        MyConstants.LOGIN_URI,
        {"phone": phone, "password": password});
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);
    //We also need to save the token locally because when we kill the app the above information that was stored in the memory will be gone
    return await sharedPreferences.setString(MyConstants.TOKEN, token);
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(MyConstants.PHONE, number);
      await sharedPreferences.setString(MyConstants.PASSWORD, password);
    } catch (e) {
      throw e;
    }
  }

  //logout
  bool clearSharedData() {
    sharedPreferences.remove(MyConstants.TOKEN);
    sharedPreferences.remove(MyConstants.PASSWORD);
    //We should be using phone number to log in but now we using email I will work on that
    sharedPreferences.remove(MyConstants.PHONE);
    apiClient.token = '';
    apiClient.updateHeader('');

    return true;
  }

  //Updating token for our Firebase
  Future<Response> updateToken() async {
    String? _deviceToken;
    //We check if IOS or not cuz there are some speical settings for IOS and request permission
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        _deviceToken = await _saveDeviceToken();
        print("Line 86 authrepo. My token is 1 " + _deviceToken!);
      }
      //This for Android
      else {
        _deviceToken = await _saveDeviceToken();
        print("Line 86 authrepo. My token is 2 " + _deviceToken!);
      }
    }
    if (!GetPlatform.isWeb) {
      //FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic)
    }
    //Sending data to our DB
    return await apiClient.postData(MyConstants.TOKEN_URI,
        {"_method": "put", "cm_firebase_token": _deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? _deviceToken = '@';
    if (!GetPlatform.isWeb) {
      try {
        //getting reqquest permission
        FirebaseMessaging.instance.requestPermission();
        //Getting the token
        _deviceToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        print("line 117 authrepo. Could not get the token");
        print(e.toString());
      }
    }
    if (_deviceToken != null) {
      print('------------Device Token------------------------' + _deviceToken);
    }
    return _deviceToken;
  }
}
