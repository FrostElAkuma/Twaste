//I had imported dart:ui instead of material.dart and it was giving me errors when i tried using the fonts. So make sure to always import the correct package
import 'package:flutter/material.dart';

import 'package:twaste/utils/dimensions.dart';

final robotoRegular = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    fontSize: Dimensions.font26);

final robotoMedium = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    fontSize: Dimensions.font26);

final robotoBold = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    fontSize: Dimensions.font26);

final robotoBlack = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w900,
    fontSize: Dimensions.font26);
