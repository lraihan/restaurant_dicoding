import 'package:flutter/material.dart';

class ColorPickerProvider with ChangeNotifier {
  Color _selectedColor;

  ColorPickerProvider(this._selectedColor);

  Color get selectedColor => _selectedColor;

  void setSelectedColor(Color color) {
    _selectedColor = color;
    notifyListeners();
  }
}
