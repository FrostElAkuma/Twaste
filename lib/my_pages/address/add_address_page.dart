import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:twaste/controllers/auth_controller.dart';
import 'package:twaste/controllers/location_controller.dart';
import 'package:twaste/controllers/user_controller.dart';
import 'package:twaste/models/address_model.dart';
import 'package:twaste/my_widgets/input_field.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../my_widgets/myIcons.dart';

//We almost always used a stateless class in this app but this one is stateful cuz we want an init class
class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  late bool _isLogged;
  //Camera view for the maps. It comes from the googlemaps package
  CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(45.5156, -122.677433), zoom: 17);
  late LatLng _initialPosition = LatLng(45.5156, -122.677433);

  @override
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    //if user model is null that means it has not yet been imported from the DB so we get it
    if (_isLogged && Get.find<UserController>().userModel == null) {
      Get.find<UserController>().getUserInfo();
    }
    //If the user already has an address then the Long and Lat should not be the default ones we set above
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      //Line of code below is  important so .getAddress below gets initialized
      Get.find<LocationController>().getUserAddress();
      _cameraPosition = CameraPosition(
          target: LatLng(
        double.parse(Get.find<LocationController>().getAddress["latitude"]),
        double.parse(Get.find<LocationController>().getAddress["longitude"]),
      ));

      _initialPosition = LatLng(
        double.parse(Get.find<LocationController>().getAddress["latitude"]),
        double.parse(Get.find<LocationController>().getAddress["longitude"]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address page"),
        backgroundColor: Colors.blue,
      ),
      body: GetBuilder<UserController>(builder: (userController) {
        if (userController.userModel != null &&
            _contactPersonName.text.isEmpty) {
          _contactPersonName.text = '${userController.userModel?.name}';
          _contactPersonNumber.text = '${userController.userModel?.phone}';
          //If user already has a lcoation saved in his account
          if (Get.find<LocationController>().addressList.isNotEmpty) {
            _addressController.text =
                Get.find<LocationController>().getUserAddress().address;
          }
        }
        return GetBuilder<LocationController>(builder: (locationController) {
          _addressController.text = '${locationController.placemark.name ?? ''}'
              '${locationController.placemark.locality ?? ''}'
              '${locationController.placemark.postalCode ?? ''}'
              '${locationController.placemark.country ?? ''}';
          print("address in my view is " + _addressController.text);
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: Dimensions.height20 * 7,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius15 / 3),
                    border: Border.all(width: 2, color: Colors.blue),
                  ),
                  child: Stack(
                    children: [
                      GoogleMap(
                          initialCameraPosition: CameraPosition(
                              target: _initialPosition, zoom: 17),
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: false,
                          myLocationEnabled: true,
                          onCameraIdle: () {
                            locationController.updatePosition(
                                _cameraPosition, true);
                          },
                          onCameraMove: ((position) =>
                              _cameraPosition = position),
                          onMapCreated: (GoogleMapController controller) {
                            locationController.setMapController(controller);
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.width20, top: Dimensions.height20),
                  child: SizedBox(
                    height: Dimensions.height30 + Dimensions.height20,
                    //list builder will run 3 times
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: locationController.addressTypeList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              locationController.setAddressTypeIndex(index);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width20,
                                  vertical: Dimensions.height10),
                              margin:
                                  EdgeInsets.only(right: Dimensions.width10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radius20 / 4),
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[200]!,
                                        //Generally spreadRadius is less than blurRAdius
                                        spreadRadius: 1,
                                        blurRadius: 5),
                                  ]),
                              child: Icon(
                                index == 0
                                    ? Icons.home_filled
                                    : index == 1
                                        ? Icons.work
                                        : Icons.location_on,
                                color:
                                    locationController.addressTypeIndex == index
                                        ? Colors.blue
                                        : Theme.of(context).disabledColor,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: Dimensions.height20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: LargeText(text: "Delivery Address"),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                //Address
                InputField(
                    textController: _addressController,
                    hintText: "Your adress",
                    icon: Icons.map),
                //Name
                SizedBox(
                  height: Dimensions.height20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: LargeText(text: "Contact name"),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                InputField(
                    textController: _contactPersonName,
                    hintText: "Your name",
                    icon: Icons.person),
                //Phone
                SizedBox(
                  height: Dimensions.height20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: Dimensions.width20),
                  child: LargeText(text: "Contact number"),
                ),
                SizedBox(
                  height: Dimensions.height10,
                ),
                InputField(
                    textController: _contactPersonNumber,
                    hintText: "Your number",
                    icon: Icons.phone),
              ],
            ),
          );
        });
      }),
      //Bottom nav
      bottomNavigationBar: GetBuilder<LocationController>(
        builder: (locationController) {
          return Column(
            //We use trhis mainAxisSize because our column is not wrapped inside a container (scaffold is not a good one) and cuz of that colummn is taking the whole page
            mainAxisSize: MainAxisSize.min,
            children: [
              //Save address
              Container(
                height: Dimensions.height20 * 8,
                padding: EdgeInsets.only(
                    top: Dimensions.height30,
                    bottom: Dimensions.height30,
                    left: Dimensions.width20,
                    right: Dimensions.width20),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 240, 239, 239),
                    borderRadius: BorderRadius.only(
                      //we sued *2 cuz i want 40
                      topLeft: Radius.circular(Dimensions.radius20 * 2),
                      topRight: Radius.circular(Dimensions.radius20 * 2),
                    )),
                child: Row(
                    //comment for formatting purposes
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Add to cart button
                      GestureDetector(
                        onTap: () {
                          AddressModel _addressModel = AddressModel(
                            addressType: locationController.addressTypeList[
                                locationController.addressTypeIndex],
                            contactPersonName: _contactPersonName.text,
                            contactPersonNumber: _contactPersonNumber.text,
                            address: _addressController.text,
                            latitude:
                                locationController.position.latitude.toString(),
                            longitude: locationController.position.longitude
                                .toString(),
                          );
                          locationController
                              .addAddress(_addressModel)
                              .then((response) {
                            if (response.isSuccess) {
                              //We go back to the eralier page
                              Get.toNamed(RouteHelper.getInitial());
                              Get.snackbar("Address", "Added Successfully");
                            } else {
                              Get.snackbar("Address", "Couldn't save address");
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height20,
                              bottom: Dimensions.height20,
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          child: LargeText(
                            text: "Save address",
                            color: Colors.white,
                            size: Dimensions.font26,
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
