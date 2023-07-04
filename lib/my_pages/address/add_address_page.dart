import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:twaste/base/custom_app_bar.dart';
import 'package:twaste/controllers/auth_controller.dart';
import 'package:twaste/controllers/location_controller.dart';
import 'package:twaste/controllers/user_controller.dart';
import 'package:twaste/models/address_model.dart';
import 'package:twaste/my_pages/address/pick_address_map.dart';
import 'package:twaste/my_widgets/input_field.dart';
import 'package:twaste/my_widgets/my_text.dart';
import 'package:twaste/routes/route_helper.dart';
import 'package:twaste/utils/dimensions.dart';

//We almost always used a stateless class in this app but this one is stateful cuz we want an init class
class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  bool mapIsTapped = Get.find<LocationController>().updateAddressData;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactPersonName = TextEditingController();
  final TextEditingController _contactPersonNumber = TextEditingController();
  late bool _isLogged;
  //Camera view for the maps. It comes from the googlemaps package
  CameraPosition _cameraPosition =
      const CameraPosition(target: LatLng(45.5156, -122.677433), zoom: 17);
  late LatLng _initialPosition = const LatLng(45.5156, -122.677433);
  late String city1 = "default";
  late String neighbour1;

  @override
  void initState() {
    super.initState();
    _isLogged = Get.find<AuthController>().userLoggedIn();
    //if user model is null that means it has not yet been imported from the DB so we get it
    if (_isLogged && Get.find<UserController>().userModel == null) {
      print("We are here line 42 adress page");
      Get.find<LocationController>().getAddressList();
      Get.find<UserController>().getUserInfo();
    }
    //If the user already has an address then the Long and Lat should not be the default ones we set above
    if (Get.find<LocationController>().addressList.isNotEmpty) {
      //Checking if local storage is empty or not, if it is empty then the user has logged in from a new device (part 4)
      if (Get.find<LocationController>().getUserAddressFromLocalStorage() ==
          "") {
        print("I am here line 53 addAddressPage no local storage");
        //.last cuz we want last saved address (that was the initial plan but apparent;y last saved address is first now)
        Get.find<LocationController>()
            .saveUserAddress(Get.find<LocationController>().addressList.first);
      }
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
      appBar: const CustomAppBar(title: "Address"),
      body: GetBuilder<UserController>(builder: (userController) {
        if (userController.userModel != null &&
            _contactPersonName.text.isEmpty) {
          _contactPersonName.text = '${userController.userModel?.name}';
          _contactPersonNumber.text = '${userController.userModel?.phone}';
          //If user already has a lcoation saved in his account
          if (Get.find<LocationController>().addressList.isNotEmpty) {
            print("line 86 in addAddresspage !!!!!!!!!!");
            _addressController.text =
                Get.find<LocationController>().getUserAddress().address;
            city1 = Get.find<LocationController>().getUserAddress().city;
            neighbour1 =
                Get.find<LocationController>().getUserAddress().neighbour;
          }
        }
        return GetBuilder<LocationController>(builder: (locationController) {
          _addressController.text = '${locationController.placemark.name ?? ''}'
              '${locationController.placemark.locality ?? ''}'
              '${locationController.placemark.postalCode ?? ''}'
              '${locationController.placemark.country ?? ''}';
          city1 = '${locationController.placemark.locality ?? ''}';
          neighbour1 = '${locationController.placemark.street ?? ''}';
          print(
              "line 94 addAddressPage address in my view is ${_addressController.text}");
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
                          //This gestureRecognizer for smooth navigating on google maps, I think a youtube comment mentioned this
                          gestureRecognizers: Set()
                            ..add(Factory<PanGestureRecognizer>(
                                () => PanGestureRecognizer())),
                          initialCameraPosition: CameraPosition(
                              target: _initialPosition, zoom: 17),
                          onTap: (argument) {
                            Get.toNamed(RouteHelper.getPickAddressPage(),
                                arguments: PickAddressMap(
                                  fromSignup: false,
                                  fromAddress: true,
                                  googleMapController:
                                      locationController.mapController,
                                ));
                          },
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: false,
                          myLocationEnabled: true,
                          onCameraIdle: () {
                            //This is causing the error where the address change after coming back from pick_address
                            //It is causing the error because this page is being called more than once ! thus calling update position more than once
                            //There is a function that keeps updating this page here I need to find it I go sleep now it is 1am
                            //Fixed the issue next day, simply when we go back to addAddressPage from pickAddressMap we only updatePosition after the camera moves
                            locationController.updatePosition(
                                _cameraPosition, mapIsTapped);
                          },
                          onCameraMove: (position) {
                            _cameraPosition = position;
                            //This so we only update the position when the camera is moving after we come back from pick_address_map
                            mapIsTapped = true;
                          },
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
                    color: const Color.fromARGB(255, 240, 239, 239),
                    borderRadius: BorderRadius.only(
                      //we sued *2 cuz i want 40
                      topLeft: Radius.circular(Dimensions.radius20 * 2),
                      topRight: Radius.circular(Dimensions.radius20 * 2),
                    )),
                child: Row(
                    //comment for formatting purposes
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Save adress button ?
                      GestureDetector(
                        onTap: () {
                          print("We are here line 2833333333 $city1");
                          print("We are here line 2844444444 $neighbour1");
                          AddressModel addressModel = AddressModel(
                            addressType: locationController.addressTypeList[
                                locationController.addressTypeIndex],
                            contactPersonName: _contactPersonName.text,
                            contactPersonNumber: _contactPersonNumber.text,
                            address: _addressController.text,
                            city: city1,
                            neighbour: neighbour1,
                            latitude:
                                locationController.position.latitude.toString(),
                            longitude: locationController.position.longitude
                                .toString(),
                          );
                          //If user already has a lcoation saved in his account, we update it
                          if (Get.find<LocationController>()
                              .addressList
                              .isNotEmpty) {
                            locationController
                                .updateAddress(addressModel)
                                .then((response) {
                              if (response.isSuccess) {
                                //We go back to the eralier page
                                Get.toNamed(RouteHelper.getInitial());
                                Get.snackbar("Address", "Added Successfully");
                              } else {
                                Get.snackbar(
                                    "Address", "Couldn't save address");
                              }
                            });
                          }

                          ///else if no location saved, we add a new one
                          else {
                            locationController
                                .addAddress(addressModel)
                                .then((response) {
                              if (response.isSuccess) {
                                //We go back to the eralier page
                                Get.toNamed(RouteHelper.getInitial());
                                Get.snackbar("Address", "Added Successfully");
                              } else {
                                Get.snackbar(
                                    "Address", "Couldn't save address");
                              }
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: Dimensions.height20,
                              bottom: Dimensions.height20,
                              left: Dimensions.width20,
                              right: Dimensions.width20),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                            color: Colors.blue,
                          ),
                          child: LargeText(
                            text: "Save address",
                            color: Colors.white,
                            size: Dimensions.font26,
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
