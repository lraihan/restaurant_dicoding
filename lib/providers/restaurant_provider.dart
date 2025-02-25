import 'package:flutter/material.dart';
import 'package:restaurant_app_dicoding/services/api_services.dart';
import 'package:restaurant_app_dicoding/models/restaurant_model.dart';
import 'package:restaurant_app_dicoding/widgets/snackbar.dart';
import 'package:restaurant_app_dicoding/services/database_helper.dart';
import '../models/resource.dart';

class RestaurantProvider with ChangeNotifier {
  ApiService apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Resource<List<Restaurant>> _restaurants = Loading();
  Map<String, dynamic>? _restaurantDetail;
  Resource<Restaurant> _restaurantDetailResource = Loading();
  bool _isLoading = false;
  List<Restaurant> _favorites = [];

  RestaurantProvider() {
    _loadFavorites();
  }

  Resource<List<Restaurant>> get restaurants => _restaurants;
  Map<String, dynamic>? get restaurantDetail => _restaurantDetail;
  Resource<Restaurant> get restaurantDetailResource =>
      _restaurantDetailResource;
  bool get isLoading => _isLoading;
  List<Restaurant> get favorites => _favorites;

  Future<void> fetchRestaurants(BuildContext? context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await apiService.getListOfRestaurants(context);
      _restaurants = Success(
        data.map((item) {
          clearRestaurants();
          return Restaurant.fromJson(item);
        }).toList(),
      );
    } catch (e) {
      _restaurants = Error(e.toString());
      if (context != null) {
        CustomSnackbar.showSnackbar(context, 'Failed to load restaurants: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantDetail(
    String restaurantId,
    BuildContext? context,
  ) async {
    _restaurantDetailResource = Loading();
    notifyListeners();

    try {
      final data = await apiService.getRestaurantDetail(restaurantId, context);
      _restaurantDetailResource = Success(Restaurant.fromJson(data));
    } catch (e) {
      _restaurantDetailResource = Error(e.toString());
      if (context != null) {
        CustomSnackbar.showSnackbar(
          context,
          'Failed to fetch restaurant details: $e',
        );
      }
    } finally {
      notifyListeners();
    }
  }

  Future<void> searchRestaurants(String query, BuildContext? context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await apiService.searchRestaurants(query, context);
      _restaurants = Success(
        data.map((item) => Restaurant.fromJson(item)).toList(),
      );
    } catch (e) {
      _restaurants = Error(e.toString());
      if (context != null) {
        CustomSnackbar.showSnackbar(
          context,
          'Failed to search restaurants: $e',
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFavorites() async {
    _favorites = await _dbHelper.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(Restaurant restaurant) async {
    await _dbHelper.insertFavorite(restaurant);
    _favorites.add(restaurant);
    notifyListeners();
  }

  Future<void> removeFavorite(Restaurant restaurant) async {
    await _dbHelper.deleteFavorite(restaurant.id!);
    _favorites.removeWhere((item) => item.id == restaurant.id);
    notifyListeners();
  }

  bool isFavorite(Restaurant restaurant) {
    return _favorites.any((item) => item.id == restaurant.id);
  }

  void clearRestaurants() {
    _restaurants = Success([]);
    notifyListeners();
  }
}
