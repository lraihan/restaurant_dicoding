import 'package:flutter/material.dart';

double screenWidth(context) => MediaQuery.of(context).size.width;
double screenHeight(context) => MediaQuery.of(context).size.height;

double horizontalPadding(context) => screenWidth(context) * .04;
double verticalPadding(context) => screenHeight(context) * .03;
