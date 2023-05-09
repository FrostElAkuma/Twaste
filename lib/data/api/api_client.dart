import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twaste/utils/my_constants.dart';

class ApiClient extends GetConnect implements GetxService {
  late String token;
  final String appBaseUrl;
  //Map is for staring data locally or converting data to map
  late Map<String, String> _mainHeaders;
  late SharedPreferences sharedPreferences;

  //Our constructor
  //The ApiClient talks to the server, and everytime we talk to the server we need to mention the header in the url whether it is a get or post request
  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    //These 2 variables are related with Getx package managment system. It needs to know the base url
    baseUrl = appBaseUrl;
    //Each time you make a request, how long should the request try, and after that whether it continous or not (trying to get data from the server for 30 seconds otherwise stop)
    timeout = const Duration(seconds: 30);
    //token = MyConstants.TOKEN;
    //Below the ?? "" is VIP took me 1 hour to debugg. I had a ! null checker there and it used to give me errors for ew device
    // ?? if token not found we set it to "". Usually "" for new devices but once they log in, it will be saved in cache i think
    token = sharedPreferences.getString(MyConstants.TOKEN) ?? "";
    _mainHeaders = {
      //key : value
      //This content type, whenevr i am getting a response from the server i am telling the server to send me json data and when i am using post the server understands that it is getting json data
      'Content-type': 'application/json; charset=UTF-8',
      //token for post requests. Bearer for authentication. The usual thing just like web
      'Authorization': 'Bearer $token',
    };
  }

  void updateHeader(String token) {
    _mainHeaders = {
      //This content type, whenevr i am getting a response from the server i am telling the server to send me json data and when i am using post the server understands that it is getting json data
      'Content-type': 'application/json; charset=UTF-8',
      //token for post requests. Bearer for authentication. The usual thing just like web
      'Authorization': 'Bearer $token',
    };
  }

  //<Response> is the response from the Getx package. Instead of http client here we are using Getx client to get data from server and it returns a response to you (<Response>) which is the data
  //Getx technically usees http inside it
  //This is a get method to get data from our server
  //We put headers as an argument cuz as we saw in postman the server needs some headers some times to get the data
  Future<Response> getData(
      //We put the question mark cuz some times headers can be empty. Also note that when we send teh headers the token will be sent automatically ?
      String uri,
      //Between curly braces so that means the argument is optional
      {Map<String, String>? headers}) async {
    //Inside the try we will call something from the server
    try {
      //this is our get request and it saves the data inside a Response object
      //it does not want the complete uri. It just wants the end point. we already have the base Url we declared it above
      Response response = await get(uri,
          //the ?? means if the headers is empty we will send _mainHeaders
          headers: headers ?? _mainHeaders);
      return response;
    }
    //If it fails we will catch the error here. e is for error
    catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  //
  Future<Response> postData(String uri, dynamic body) async {
    print("We are inside api_client line 67");
    print(body.toString());
    try {
      //This post method is from getX package. We are not using http client
      //body is the information I am sending
      //We sending headers so we tell the server that we are giving it some content and the type is Json. We also the token is important for post methods
      //response so we know what is the response from our server
      Response response = await post(uri, body, headers: _mainHeaders);
      print("We are inside api_client line 75");
      print(response.body.toString());
      return response;
    }
    //If something goes wrong we catch it. e stands for error here
    catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
}
