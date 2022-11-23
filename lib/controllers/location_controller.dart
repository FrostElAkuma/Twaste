import 'dart:convert';

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
  //this coming from geolocator package
  late Position _position;
  late Position _pickPosition;

  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;

  //List of type AddressModel
  //This to save adress in the memory
  List<AddressModel> _addressList = [];
  List<AddressModel> get addressList => _addressList;

  late List<AddressModel> _allAddressList;
  List<AddressModel> get allADdressList => _allAddressList;

  List<String> _addressTypeList = ["home", "office", "others"];
  List<String> get addressTypeList => _addressTypeList;
  int _addressTypeIndex = 0;
  int get addressTypeIndex => _addressTypeIndex;

  late GoogleMapController _mapController;
  GoogleMapController get mapControlelr => _mapController;

  bool _updateAddressData = true;
  bool _changeDdress = true;

  bool get loading => _loading;
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

        if (_changeDdress) {
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
    }
  }

  Future<String> getADdressfromGeocode(LatLng latLng) async {
    String _address = "Unkown Location Found";
    //talking to our server then our server will talk to the google server
    Response response = await locationRepo.getADdressfromGeocode(latLng);
    if (response.body["status"] == 'OK') {
      _address = response.body["results"][0]['formatted_address'].toString();
      //for debugging purposes
      print("printing address " + _address);
    } else {
      print("Error getting the google api");
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
      await getAddressList();
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
    Response response = await locationRepo.getAllAddress();
    if (response.statusCode == 200) {
      //Making sure that they are empty just in case some one changes their account ID
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address) {
        _addressList.add(AddressModel.fromJson(address));
        _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }
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
}
