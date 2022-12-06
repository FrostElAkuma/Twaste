import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:twaste/data/repository/location_repo.dart';
import 'package:twaste/models/response_model.dart';

import '../models/address_model.dart';

class LocationController extends GetxController implements GetxService {
  LocationRepo locationRepo;
  LocationController({required this.locationRepo});

  bool _loading = false;
  bool get loading => _loading;

  //this coming from geolocator package
  late Position _position;
  late Position _pickPosition;

  //For service zone
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  //whether use is within the service zone
  bool _inZone = false;
  bool get inZone => _inZone;
  //Showing and hiding the button as the map laods
  //The default value should be true but I will put it false until I get teh zoens working
  bool _buttonDisabled = false;
  bool get buttonDisabled => _buttonDisabled;

  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;

  //List of type AddressModel
  //This to save adress in the memory
  //_addressList being empty when i start the app is giving me problems. The only place where _addressList gets initialized is in getAddressList
  //which is only called from AddAddress which is only called once when you press the save address buttonm :/
  //I think it is empty every time i refresh the app cuz the data is not being initialized on app start ?
  //fixed this issue by simply calling getAddress list when the user go to the profile page as well instead of once when the save address button is presses
  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;

  late List<AddressModel> _allAddressList;
  List<AddressModel> get allAddressList => _allAddressList;

  List<String> _addressTypeList = ["home", "office", "others"];
  List<String> get addressTypeList => _addressTypeList;
  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _mapController;
  GoogleMapController get mapControlelr => _mapController;

  bool _updateAddressData = true;
  //I added this
  bool get updateAddressData => _updateAddressData;
  bool _changeAddress = true;

  Position get position => _position;
  Position get pickPosition => _pickPosition;

  void setMapController(GoogleMapController mapController) {
    _mapController = mapController;
  }

  void updatePosition(CameraPosition position, bool fromAddress) async {
    if (_updateAddressData) {
      _loading = true;
      update();
      try {
        //If from address page
        if (fromAddress) {
          _position = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        }
        //If from other pages
        else {
          _pickPosition = Position(
            latitude: position.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
          );
        }

        //Every time the map is moved we check the zone and disable the button
        /*ResponseModel _responseModel = await getZone(
            position.target.latitude.toString(),
            position.target.longitude.toString(),
            false);
        //Checking the response. If hte button value is false then we are within the service area
        _buttonDisabled = !_responseModel.isSuccess;*/
        //_buttonDisabled = false;
        if (_changeAddress) {
          //Grabbing the this String from the google server
          String _address = await getADdressfromGeocode(
            LatLng(position.target.latitude, position.target.longitude),
          );
          //If we are coming from address page
          fromAddress
              ? _placemark = Placemark(name: _address)
              : _pickPlacemark = Placemark(name: _address);
          //Good for debugging
          //print(_placemark.)
        }
      } catch (e) {
        print(e);
      }

      _loading = false;
      update();
    } else {
      _updateAddressData = true;
    }
  }

  Future<String> getADdressfromGeocode(LatLng latLng) async {
    String _address = "Unkown Location Found";
    //talking to our server then our server will talk to the google server
    Response response = await locationRepo.getADdressfromGeocode(latLng);
    if (response.body["status"] == 'OK') {
      _address = response.body["results"][0]['formatted_address'].toString();
      //for debugging purposes
      print("printing address line 135 in location controller" + _address);
    } else {
      print("Error getting the google api " + response.body.toString());
    }
    update();
    return _address;
  }

  //This will be coming from DB
  late Map<String, dynamic> _getAddress;
  Map get getAddress => _getAddress;

  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    //converting to map using jsonDecode
    _getAddress = jsonDecode(locationRepo.getUserAddress());
    try {
      _addressModel =
          AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    } catch (e) {
      print(e);
    }
    return _addressModel;
  }

  //For another address
  void setAddressTypeIndex(int index) {
    _addressTypeIndex = index;
    update();
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      //To save them in the memory
      print("I am here 4 at line 173 Location controller");
      await getAddressList();
      print("I am here 7 at line 175 lcoation controller");
      //This message comes from our api
      String message = response.body["message"];
      responseModel = ResponseModel(true, message);
      //Reminder Any Future function we better have await when calling it
      await saveUserAddress(addressModel);
    } else {
      print("could not save the address");
      responseModel = ResponseModel(false, response.statusText!);
    }
    update();
    return responseModel;
  }

  //To save thee address in the memory ?
  Future<void> getAddressList() async {
    _loading = true;
    print(
        "Are we loading ? Line 197 location controller " + _loading.toString());
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      print("I am here 5 at line 193 location controller");
      //Making sure that they are empty just in case some one changes their account ID
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        print("Location contreoller line 198" + address.toString());
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
      _loading = false;
      update();
    } else {
      print("I am here 6 at line 203 Location controller");
      _addressList = [];
      _allAddressList = [];
    }

    print(
        "Are we loading ? Line 212 location controller " + _loading.toString());
    update();
  }

  //To save teh address in the lcoal storage
  Future<bool> saveUserAddress(AddressModel addressModel) async {
    //converting data to string so we can save them in our sharedpreferances
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }

  //When user logs out we need to clear the local storage
  void clearAddressList() {
    _addressList = [];
    _allAddressList = [];
    update();
  }

  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }

  //Saving new address after moving the camera
  void setAddAddressData() {
    _position = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData = false;
    update();
  }

  /*Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _responseModel;
    //if it is true
    if (markerLoad) {
      _loading = true;
    } else {
      _isLoading = true;
    }
    update();
    Response response = await locationRepo.getZone(lat, lng);
    //It is important that when you do a network request that you check the response
    if (response.statusCode == 200) {
      print("We are here 1" + response.body.toString());
      _responseModel = ResponseModel(false, response.statusText!);
      //Simulating if we not in zone
      if (response.body["zone_id"] != 2) {
        print("We are here 2");
        _responseModel =
            ResponseModel(false, response.body["zone_id"].toString());
        _inZone = false;
      } else {
        print("We are here 3");
        _responseModel =
            ResponseModel(true, response.body["zone_id"].toString());
        _inZone = true;
      }
    } else {
      _inZone = false;
      _responseModel = ResponseModel(false, response.statusText!);
    }
    if (markerLoad) {
      _loading = false;
    } else {
      _isLoading = false;
    }
    print("This is the status code given inside getZone" +
        response.statusCode.toString());
    update();

    return _responseModel;
  }*/
}
