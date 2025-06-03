import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomColorMapper extends ColorMapper {
  final BuildContext context;
  const CustomColorMapper(this.context);

  @override
  Color substitute(
      String? id,
      String elementName,
      String attributeName,
      Color color,
      ) {
    if (color == const Color(0xFFF7C846)) {
      return Theme.of(context).colorScheme.primary;
    } else if (color == const Color(0xFF0000FF)) {
      return Color(0xFF5dd0f0);
    } else if (color == const Color(0xFFF0F0F0)) {
      return Theme.of(context).colorScheme.onPrimary;
    }


    return color;
  }
}