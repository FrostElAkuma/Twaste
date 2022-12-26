import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twaste/data/api/api_client.dart';
import 'package:twaste/models/address_model.dart';

import '../../utils/my_constants.dart';

class LocationRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LocationRepo({required this.apiClient, required this.sharedPreferences});

  //This is a get request to the server and it gets data from the server
  Future<Response> getADdressfromGeocode(LatLng latlng) async {
    return await apiClient.getData('${MyConstants.GEOCODE_URI}'
        '?lat=${latlng.latitude}&lng=${latlng.longitude}');
  }

  //Get method
  String getUserAddress() {
    print("We are here 1 line 23 in location repo");
    return sharedPreferences.getString(MyConstants.USER_ADDRESS) ?? "";
  }

  //Post method to send user location data to server
  Future<Response> addAddress(AddressModel addressModel) async {
    print("We are here 2 line 28 in location repo");
    return await apiClient.postData(
        MyConstants.ADD_USER_ADDRESS, addressModel.toJson());
  }

  Future<Response> getAllAddress() async {
    print("We are here 3 line 34 in location repo");
    return await apiClient.getData(MyConstants.ADDRESS_LIST_URI);
  }

  Future<bool> saveUserAddress(String address) async {
    print("We are here 4 line 39 in location repo");
    apiClient.updateHeader(sharedPreferences.getString(MyConstants.TOKEN)!);
    return await sharedPreferences.setString(MyConstants.USER_ADDRESS, address);
  }

  Future<Response> getZone(String lat, String lng) async {
    print("We are here 5" + lat + " aa " + lng);
    return await apiClient.getData('${MyConstants.ZONE_URI}?lat=$lat&lng=$lng');
  }

  Future<Response> searchLoaction(String text) async {
    return await apiClient
        .getData('${MyConstants.SEARCH_LOCATION_URI}?search_text=$text');
  }
}
