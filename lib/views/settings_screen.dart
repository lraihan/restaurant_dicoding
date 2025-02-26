import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/services/workmanager_service.dart';
import 'package:restaurant_app_dicoding/services/notification_service.dart';
import 'package:restaurant_app_dicoding/widgets/color_picker_dialog.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding(context)),
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding(context),
              ),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SwitchListTile(
              title: const Text('Enable Notification'),
              value: themeProvider.notificationsEnabled,
              inactiveThumbColor: blackColor,
              inactiveTrackColor: blackColor.shade200,
              onChanged: (value) async {
                themeProvider.toggleNotifications(value);
                if (value) {
                  await Provider.of<WorkmanagerService>(
                    context,
                    listen: false,
                  ).runPeriodicTask(
                    themeProvider.notificationTime.hour,
                    themeProvider.notificationTime.minute,
                  );
                } else {
                  await Provider.of<WorkmanagerService>(
                    context,
                    listen: false,
                  ).cancelAllTask();
                  await NotificationService().flutterLocalNotificationsPlugin
                      .cancelAll();
                }
              },
            ),
            SizedBox(height: verticalPadding(context)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding(context),
              ),
              child: Text(
                'Theme Settings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            _buildThemeModeRadio(ThemeMode.system, 'System Theme', context),
            _buildThemeModeRadio(ThemeMode.light, 'Light Theme', context),
            _buildThemeModeRadio(ThemeMode.dark, 'Dark Theme', context),
            SwitchListTile(
              title: const Text('Use Seed Color'),
              value: themeProvider.useSeedColor,
              inactiveThumbColor: blackColor,
              inactiveTrackColor: blackColor.shade200,
              onChanged: (value) => themeProvider.toggleSeedColor(value),
            ),
            if (themeProvider.useSeedColor)
              ListTile(
                title: const Text('Select Seed Color'),
                trailing: ColorPickerButton(
                  initialColor: themeProvider.seedColor,
                  onColorChanged: (color) => themeProvider.setSeedColor(color),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeRadio(
    ThemeMode mode,
    String label,
    BuildContext context,
  ) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: mode,
      groupValue: themeProvider.themeMode,
      onChanged: (value) => themeProvider.setThemeMode(value!),
    );
  }
}

class ColorPickerButton extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerButton({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.color_lens, color: initialColor),
      onPressed:
          () => showDialog(
            context: context,
            builder:
                (context) => ColorPickerDialog(
                  initialColor: initialColor,
                  onColorChanged: onColorChanged,
                ),
          ),
    );
  }
}
