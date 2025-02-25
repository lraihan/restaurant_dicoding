import 'package:flutter/material.dart';
import 'package:restaurant_app_dicoding/models/restaurant_model.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';
import 'package:restaurant_app_dicoding/views/restaurant_detail.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;
  final String heroTag;
  final VoidCallback? onDelete;

  const RestaurantItem({super.key, required this.restaurant, required this.heroTag, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RestaurantDetail(restaurantId: restaurant.id!, heroTag: heroTag)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: screenHeight(context) * .01,
              horizontal: screenWidth(context) * .02,
            ),
            child: SizedBox(
              width: screenWidth(context) * .8,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child:
                        restaurant.pictureId != null
                            ? Hero(
                              tag: heroTag,
                              child: Image.network(
                                'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                                fit: BoxFit.cover,
                                height: screenHeight(context) * .13,
                                width: screenWidth(context) * .35,
                                errorBuilder: (_, __, ___) {
                                  return Icon(
                                    Icons.error_outline,
                                    color: themeProvider.seedColor,
                                    size: screenWidth(context) * .3,
                                  );
                                },
                                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress.expectedTotalBytes != null
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
                  SizedBox(width: screenWidth(context) * .02),
                  SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: screenWidth(context) * .37,
                              child: Text(restaurant.name ?? '-', style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_pin, color: themeProvider.seedColor, size: 16),
                                SizedBox(width: 4),
                                Text(restaurant.city ?? '-', style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight(context) * .03),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            Text(restaurant.rating.toString(), style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(icon: Icon(Icons.close, color: errorColor, size: 20), onPressed: onDelete),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
