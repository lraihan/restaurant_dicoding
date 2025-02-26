import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/models/resource.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/views/search_result.dart';
import 'package:restaurant_app_dicoding/widgets/color_picker_dialog.dart';
import 'package:restaurant_app_dicoding/views/favorite_restaurants.dart';
import 'package:restaurant_app_dicoding/services/notification_service.dart';
import 'package:restaurant_app_dicoding/widgets/restaurant_item.dart';
import 'package:restaurant_app_dicoding/views/settings_screen.dart';

class RestaurantList extends StatelessWidget {
  const RestaurantList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final restaurantProvider = Provider.of<RestaurantProvider>(
      context,
      listen: false,
    );
    final FocusNode searchFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      restaurantProvider.fetchRestaurants(context);
      NotificationService().requestPermission(
        context,
      ); // Request notification permission on app startup
    });

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await restaurantProvider.fetchRestaurants(context);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding(context),
            vertical: verticalPadding(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: verticalPadding(context)),
              TextField(
                onTapOutside: (event) {
                  searchFocusNode.unfocus();
                },
                focusNode: searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: themeProvider.seedColor,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeProvider.seedColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeProvider.seedColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: themeProvider.seedColor,
                      width: 2,
                    ),
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
              SizedBox(height: verticalPadding(context) * .5),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingsScreen(),
                            ),
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
                      return Center(
                        child: Text(
                          'Failed To Load Restaurant Data, Please Try Again',
                        ),
                      );
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
      ),
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
