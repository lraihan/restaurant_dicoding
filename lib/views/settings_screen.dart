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
            if (themeProvider.notificationsEnabled)
              Column(
                children: [
                  ListTile(
                    title: const Text('Set Lunch Notification Time'),
                    subtitle: Text(
                      themeProvider.notificationTime.format(context),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: themeProvider.notificationTime,
                        );
                        if (picked != null) {
                          themeProvider.setNotificationTime(picked);

                          await Provider.of<WorkmanagerService>(
                            context,
                            listen: false,
                          ).cancelAllTask();
                          await Provider.of<WorkmanagerService>(
                            context,
                            listen: false,
                          ).runPeriodicTask(
                            themeProvider.notificationTime.hour,
                            themeProvider.notificationTime.minute,
                          );

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Notification Set',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                content: Text(
                                  'Lunch notification set at ${picked.format(context)}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Test Notification'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        /* final resource = Provider.of<RestaurantProvider>(context, listen: false).restaurants;
                        final restaurants = (resource as Success).data;
                        final Restaurant randomRestaurant = restaurants[Random().nextInt(restaurants.length)];
                        await NotificationService().showNotification(
                          restaurantName: randomRestaurant.name ?? '-',
                          restaurantAddress: randomRestaurant.address ?? '-',
                        ); */
                      },
                      child: Text(
                        'Show Now',
                        style: TextStyle(
                          color:
                              themeProvider.themeMode == ThemeMode.light
                                  ? themeProvider.seedColor
                                  : MediaQuery.of(context).platformBrightness ==
                                      Brightness.light
                                  ? themeProvider.seedColor
                                  : whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
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
