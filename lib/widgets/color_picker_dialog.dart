import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/color_picker_provider.dart';

class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerDialog({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ColorPickerProvider(initialColor),
      child: Consumer<ColorPickerProvider>(
        builder: (context, colorPickerProvider, child) {
          return AlertDialog(
            title: const Text('Pick a seed color'),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: colorPickerProvider.selectedColor,
                onColorChanged:
                    (color) => colorPickerProvider.setSelectedColor(color),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  onColorChanged(colorPickerProvider.selectedColor);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );
  }
}
