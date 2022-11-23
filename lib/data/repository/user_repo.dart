import 'package:get/get_connect/http/src/response/response.dart';
import 'package:twaste/data/api/api_client.dart';
import 'package:twaste/utils/my_constants.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> getUserInfo() async {
    return await apiClient.getData(MyConstants.USER_INFO_URI);
  }
}
