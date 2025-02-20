import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';
import 'package:restaurant_app_dicoding/views/restaurant_detail.dart';
import 'package:restaurant_app_dicoding/views/search_result.dart';
import 'package:restaurant_app_dicoding/widgets/color_picker_dialog.dart';
import '../models/resource.dart';
import 'package:restaurant_app_dicoding/views/favorite_restaurants.dart';
import 'package:restaurant_app_dicoding/services/notification_service.dart';

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
                      icon: Icon(Icons.favorite),
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
                      icon: Icon(Icons.settings),
                      onPressed: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
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
                                        await NotificationService().scheduleDailyNotification(
                                            context: context, id: 0, time: themeProvider.notificationTime);
                                      } else {
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
                                                await NotificationService().scheduleDailyNotification(
                                                    context: context, id: 0, time: themeProvider.notificationTime);
                                              }
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('Test Notification'),
                                          trailing: ElevatedButton(
                                            onPressed: () async {
                                              await NotificationService().showNotification(context);
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
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
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
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: blackColor.shade100),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight(context) * .01, horizontal: screenWidth(context) * .02),
                            leading: SizedBox(
                              width: screenWidth(context) * .3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: restaurant.pictureId != null
                                    ? Hero(
                                        tag: heroTag,
                                        child: Image.network(
                                          'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                          (loadingProgress.expectedTotalBytes ?? 1)
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      )
                                    : Center(child: CircularProgressIndicator()),
                              ),
                            ),
                            title: Text(restaurant.name ?? '-'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(restaurant.city ?? '-'),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    Text(restaurant.rating.toString()),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RestaurantDetail(
                                    restaurantId: restaurant.id!,
                                    heroTag: heroTag,
                                  ),
                                ),
                              );
                            },
                          ),
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
