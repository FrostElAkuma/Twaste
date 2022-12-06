import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:twaste/base/custom_button.dart';
import 'package:twaste/controllers/location_controller.dart';
import 'package:twaste/utils/dimensions.dart';

import '../../routes/route_helper.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromSignup;
  final bool fromAddress;
  //We want to create 1 google map instance and use it and pass it around our app
  final GoogleMapController? googleMapController;

  const PickAddressMap(
      {super.key,
      required this.fromSignup,
      required this.fromAddress,
      this.googleMapController});

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Checking if user already has an address
    if (Get.find<LocationController>().addressList.isEmpty) {
      print("Line 40 in pickAddressMap, AddressList is empty");
      _initialPosition = LatLng(45.521563, -122.677433);
      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
    }
    //If addressLsit is not empty that means we can get the info from the serve
    else {
      if (Get.find<LocationController>().addressList.isNotEmpty) {
        //Getting the data from local sotrage
        _initialPosition = LatLng(
            double.parse(Get.find<LocationController>().getAddress["latitude"]),
            double.parse(
                Get.find<LocationController>().getAddress["longitude"]));
        _cameraPosition = CameraPosition(target: _initialPosition, zoom: 17);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(builder: (locationcController) {
      return Scaffold(
        body: SafeArea(
            child: Center(
          child: SizedBox(
            width: double.maxFinite,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 17,
                  ),
                  //Disabling zoom in
                  zoomControlsEnabled: false,
                  onCameraMove: (CameraPosition cameraPosition) {
                    //As the camera is moving we are save the new postion to _caneraPosition instantly
                    _cameraPosition = cameraPosition;
                  },
                  onCameraIdle: () {
                    Get.find<LocationController>()
                        .updatePosition(_cameraPosition, false);
                  },
                ),
                //Loading Icon
                Center(
                  //We used get builder for this
                  child: !locationcController.loading
                      ? Image.asset(
                          "assets/images/cat.jpg",
                          height: 50,
                          width: 50,
                        )
                      : CircularProgressIndicator(),
                ),
                //To show address
                Positioned(
                  top: Dimensions.height45,
                  left: Dimensions.width20,
                  right: Dimensions.width20,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: Dimensions.width10),
                    height: (Dimensions.height20 * 2 + Dimensions.height10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.circular(Dimensions.radius20 / 2),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 25,
                          color: Colors.yellow,
                        ),
                        Expanded(
                          child: Text(
                            '${locationcController.pickPlacemark.name ?? ''}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.font16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: Dimensions.height20 * 4,
                    left: Dimensions.width20,
                    right: Dimensions.width20,
                    child: locationcController.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomButton(
                            buttonText: !locationcController.inZone
                                ? widget.fromAddress
                                    ? 'Pick Address'
                                    : 'Pick Location'
                                : 'Service is not available in your area',
                            //While it is loading we can't press the button
                            onPressed: (locationcController.buttonDisabled ||
                                    locationcController.loading)
                                ? null
                                : () {
                                    //making sure that the user selected something
                                    if (locationcController
                                                .pickPosition.latitude !=
                                            0 &&
                                        locationcController
                                                .pickPlacemark.name !=
                                            null) {
                                      //checking from where we came
                                      if (widget.fromAddress) {
                                        //map has been created
                                        if (widget.googleMapController !=
                                            null) {
                                          print(
                                              "Now you clicked on this Pick Address");
                                          //Updating address to new location chosen
                                          widget.googleMapController!
                                              .moveCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                target: LatLng(
                                                  locationcController
                                                      .pickPosition.latitude,
                                                  locationcController
                                                      .pickPosition.longitude,
                                                ),
                                              ),
                                            ),
                                          );
                                          locationcController
                                              .setAddAddressData();
                                        }
                                        //we usedGet.back() here first but it causes update problems
                                        Get.toNamed(
                                            RouteHelper.getAddressPage());
                                        //Get.back();
                                      }
                                    }
                                  },
                          ))
              ],
            ),
          ),
        )),
      );
    });
  }
}
