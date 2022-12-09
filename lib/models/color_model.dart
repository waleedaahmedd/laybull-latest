import 'package:flutter/material.dart';

class ColorClass {
  int colorValue;
  bool isSelected;
  String colorName;
  ColorClass({
    required this.colorValue,
    required this.isSelected,
    required this.colorName,
  });
}

// black white green red blue yellow  purple pink brown orange grey khaki
List<ColorClass> colorList = [
  ColorClass(
    colorValue: 0xff000000,
    colorName: "Black",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0x00000000,
    colorName: "White",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0xff008000,
    colorName: "Green",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0xffFF0000,
    colorName: "Red",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0xff0000FF,
    colorName: "Blue",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0xffFFFF00,
    colorName: "Yellow",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0xff800080,
    colorName: "Purple",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0xffFFC0CB,
    colorName: "Pink",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0xffA52A2A,
    colorName: "Brown",
    isSelected: false,
  ),
  ColorClass(colorValue: 0xffFFA500, isSelected: false, colorName: "Orange"),
  ColorClass(
    colorValue: 0xff808080,
    colorName: "Grey",
    isSelected: false,
  ),
  ColorClass(
    colorValue: 0xfff0e68c,
    colorName: "Khaki",
    isSelected: false,
  ),
];
