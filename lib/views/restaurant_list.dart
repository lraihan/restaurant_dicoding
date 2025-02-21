import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/services/workmanager_service.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';
import 'package:restaurant_app_dicoding/views/search_result.dart';
import 'package:restaurant_app_dicoding/widgets/color_picker_dialog.dart';
import '../models/resource.dart';
import 'package:restaurant_app_dicoding/views/favorite_restaurants.dart';
import 'package:restaurant_app_dicoding/services/notification_service.dart';
import 'package:restaurant_app_dicoding/widgets/restaurant_item.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurantProvider.fetchRestaurants(context);
      NotificationService().requestPermission(context); // Request notification permission on app startup
    });

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding(context), vertical: verticalPadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: verticalPadding(context),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(
                  Icons.search,
                  color: themeProvider.seedColor,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: themeProvider.seedColor, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onSubmitted: (query) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResult(query: query),
                  ),
                );
              },
            ),
            SizedBox(
              height: verticalPadding(context) * .5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Restaurants you may like..',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: themeProvider.seedColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoriteRestaurants(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        color: themeProvider.seedColor,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: false,
                          showDragHandle: true,
                          context: context,
                          scrollControlDisabledMaxHeightRatio: 0.75,
                          builder: (context) {
                            return Padding(
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
                                        await Provider.of<WorkmanagerService>(context, listen: false)
                                            .runOneOffTask(context);
                                      } else {
                                        await Provider.of<WorkmanagerService>(context, listen: false).cancelAllTask();
                                        await NotificationService().flutterLocalNotificationsPlugin.cancelAll();
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

                                                await Provider.of<WorkmanagerService>(context, listen: false)
                                                    .cancelAllTask();
                                                await Provider.of<WorkmanagerService>(context, listen: false)
                                                    .runOneOffTask(context);

                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text('Notification Set',
                                                          style: Theme.of(context).textTheme.titleMedium),
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
                                              await NotificationService().showNotification();
                                            },
                                            child: const Text('Show Now'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: verticalPadding(context),
                                  ),
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
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Consumer<RestaurantProvider>(
                builder: (context, restaurantProvider, child) {
                  final resource = restaurantProvider.restaurants;

                  if (resource is Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (resource is Error) {
                    return Center(child: Text((resource as Error).message));
                  } else if (resource is Success) {
                    final restaurants = (resource as Success).data;
                    if (restaurants.isEmpty) {
                      return Center(child: Text('No restaurants found.'));
                    }

                    return ListView.builder(
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurants[index];
                        final heroTag = 'restaurant-image-${restaurant.id}';
                        return RestaurantItem(
                          restaurant: restaurant,
                          heroTag: heroTag,
                        );
                      },
                    );
                  }

                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeRadio(ThemeMode mode, String label, BuildContext context) {
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
      onPressed: () => showDialog(
        context: context,
        builder: (context) => ColorPickerDialog(
          initialColor: initialColor,
          onColorChanged: onColorChanged,
        ),
      ),
    );
  }
}
