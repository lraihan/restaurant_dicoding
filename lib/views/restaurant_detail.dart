import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/review_provider.dart';
import 'package:restaurant_app_dicoding/services/api_services.dart';
import 'package:restaurant_app_dicoding/models/restaurant_model.dart';
import 'package:restaurant_app_dicoding/shared/consts.dart';
import 'package:restaurant_app_dicoding/views/add_review_screen.dart';

class RestaurantDetail extends StatefulWidget {
  final String restaurantId;
  final String heroTag;

  const RestaurantDetail({
    super.key,
    required this.restaurantId,
    required this.heroTag,
  });

  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantProvider()..fetchRestaurantDetail(widget.restaurantId, context),
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<RestaurantProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Text('Loading...');
              } else if (provider.restaurantDetail == null) {
                return Text('No data');
              } else {
                final restaurant = Restaurant.fromJson(provider.restaurantDetail!);
                return Text(restaurant.name ?? '-');
              }
            },
          ),
        ),
        body: Consumer<RestaurantProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (provider.restaurantDetail == null) {
              return Center(child: Text('No data found.'));
            } else {
              final restaurant = Restaurant.fromJson(provider.restaurantDetail!);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: FutureBuilder<File>(
                        future: ApiService().getCachedImage(
                            'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}'),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return Center(child: Text('No image found.'));
                          } else {
                            return Image.file(snapshot.data!, fit: BoxFit.cover);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant.name ?? '-',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16),
                              SizedBox(width: 4),
                              Text(
                                restaurant.city ?? '-',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                restaurant.rating?.toString() ?? '-',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: verticalPadding(context),
                          ),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: verticalPadding(context) * .5,
                          ),
                          Text(
                            restaurant.description ?? '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(
                            height: verticalPadding(context),
                          ),
                          Text(
                            'Menus',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: verticalPadding(context) * .5,
                          ),
                          Text(
                            'Foods:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: verticalPadding(context) * .5,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 3,
                            ),
                            itemCount: restaurant.menus?.foods?.length ?? 0,
                            itemBuilder: (context, index) {
                              final food = restaurant.menus!.foods![index];
                              return Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      food.name ?? '-',
                                      style: Theme.of(context).textTheme.headlineSmall,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: verticalPadding(context),
                          ),
                          Text(
                            'Drinks:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: verticalPadding(context) * .5,
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 3,
                            ),
                            itemCount: restaurant.menus?.drinks?.length ?? 0,
                            itemBuilder: (context, index) {
                              final drink = restaurant.menus!.drinks![index];
                              return Card(
                                margin: EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      drink.name ?? '-',
                                      style: Theme.of(context).textTheme.headlineSmall,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: verticalPadding(context),
                          ),
                          Text(
                            'Customer Reviews',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(
                            height: verticalPadding(context) * .5,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: restaurant.customerReviews?.length ?? 0,
                            itemBuilder: (context, index) {
                              final review = restaurant.customerReviews![index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.name ?? '-',
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        review.review ?? '-',
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        review.date ?? '-',
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: verticalPadding(context),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeNotifierProvider(
                                      create: (_) => ReviewProvider(),
                                      child: AddReviewScreen(
                                        restaurantId: widget.restaurantId,
                                        onReviewAdded: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text('Add Review'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
