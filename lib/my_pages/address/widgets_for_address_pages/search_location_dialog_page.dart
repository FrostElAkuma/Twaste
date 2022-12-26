import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:twaste/utils/dimensions.dart';
import 'package:get/get.dart';

import 'package:twaste/controllers/location_controller.dart';
import 'package:google_maps_webservice/src/places.dart';

class LoactionSearch extends StatelessWidget {
  //The popUp should have access to google map
  final GoogleMapController mapController;
  const LoactionSearch({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Container(
      padding: EdgeInsets.all(Dimensions.width10),
      alignment: Alignment.topCenter,
      child:
          //Material for popUp
          Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius20 / 2),
        ),
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: SingleChildScrollView(
            //This the autofill plugin that we installed
            //Also this is what is giving me the scrollable error
            //Solved be nesting it inside a scrollable widget :)
            child: TypeAheadField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controller,
                textInputAction: TextInputAction.search,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(
                  hintText: "search location",
                  //Cuz we in input text we need to use OutlineInputBorder
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius20 / 2),
                    borderSide: BorderSide(
                      style: BorderStyle.none,
                      width: 0,
                    ),
                  ),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(
                          color: Theme.of(context).disabledColor,
                          fontSize: Dimensions.font16),
                ),
              ),
              //This so we actually select and set the location we want from the search
              onSuggestionSelected: (suggestion) {},
              //Suggestions as we type (It talks back to the google server) it will automatically get the text I am typing
              // it was (String pattern) but pattern is given a type automatically so we delted String ?
              suggestionsCallback: (pattern) async {
                return await Get.find<LocationController>()
                    .searchLocation(context, pattern);
              },
              itemBuilder: (context, Prediction suggestion) {
                return Padding(
                  padding: EdgeInsets.all(Dimensions.width10),
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      //Expanded to take the rest of the space
                      Expanded(
                        child: Text(
                          suggestion.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color,
                                fontSize: Dimensions.font16,
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
