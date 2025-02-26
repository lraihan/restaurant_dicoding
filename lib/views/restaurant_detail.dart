import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/models/resource.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/providers/review_provider.dart';
import 'package:restaurant_app_dicoding/models/restaurant_model.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).fetchRestaurantDetail(widget.restaurantId, context);
    });
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<RestaurantProvider>(
      context,
      listen: false,
    ).fetchRestaurantDetail(widget.restaurantId, context);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Consumer<RestaurantProvider>(
          builder: (context, provider, child) {
            final resource = provider.restaurantDetailResource;

            if (resource is Loading) {
              return Text('Loading...');
            } else if (resource is Error) {
              return Text('Error');
            } else if (resource is Success) {
              final restaurant = (resource as Success<Restaurant>).data;
              return Text(restaurant.name ?? '-');
            }

            return Text('Restaurant Detail');
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshData(context),
        child: Consumer<RestaurantProvider>(
          builder: (context, provider, child) {
            final resource = provider.restaurantDetailResource;

            if (resource is Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (resource is Error) {
              return Center(child: Text((resource as Error).message));
            } else if (resource is Success) {
              final restaurant = (resource as Success<Restaurant>).data;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: Image.network(
                        'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                restaurant.name ?? '-',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Consumer<RestaurantProvider>(
                                builder: (context, provider, child) {
                                  final resource =
                                      provider.restaurantDetailResource;

                                  if (resource is Success) {
                                    final restaurant =
                                        (resource as Success<Restaurant>).data;
                                    final isFavorite = provider.isFavorite(
                                      restaurant,
                                    );

                                    return IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                      ),
                                      color:
                                          isFavorite
                                              ? themeProvider.seedColor
                                              : null,
                                      onPressed: () {
                                        if (isFavorite) {
                                          provider.removeFavorite(restaurant);
                                        } else {
                                          provider.addFavorite(restaurant);
                                        }
                                      },
                                    );
                                  }

                                  return Container();
                                },
                              ),
                            ],
                          ),
                          Text(
                            restaurant.address ?? '-',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 20,
                                color: themeProvider.seedColor,
                              ),
                              SizedBox(width: 4),
                              Text(
                                restaurant.city ?? '-',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.star, size: 20, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                restaurant.rating?.toString() ?? '-',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          SizedBox(height: verticalPadding(context)),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: verticalPadding(context) * .5),
                          Text(
                            restaurant.description ?? '-',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          SizedBox(height: verticalPadding(context)),
                          Text(
                            'Menus',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: verticalPadding(context) * .5),
                          Text(
                            'Foods:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: verticalPadding(context) * .5),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: verticalPadding(context)),
                          Text(
                            'Drinks:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: verticalPadding(context) * .5),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.headlineSmall,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: verticalPadding(context)),
                          Text(
                            'Customer Reviews',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          SizedBox(height: verticalPadding(context) * .5),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        review.name ?? '-',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleSmall,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        review.review ?? '-',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        review.date ?? '-',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: verticalPadding(context)),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ChangeNotifierProvider(
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

            return Container();
          },
        ),
      ),
    );
  }
}
