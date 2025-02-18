import 'package:flutter/material.dart';
import 'package:restaurant_app_dicoding/services/api_services.dart';
import 'package:restaurant_app_dicoding/models/restaurant_model.dart';
import 'package:restaurant_app_dicoding/widgets/snackbar.dart';
import '../models/resource.dart';

class RestaurantProvider with ChangeNotifier {
  final ApiService apiService = ApiService();
  Resource<List<Restaurant>> _restaurants = Loading();
  Map<String, dynamic>? _restaurantDetail;
  bool _isLoading = false;

  Resource<List<Restaurant>> get restaurants => _restaurants;
  Map<String, dynamic>? get restaurantDetail => _restaurantDetail;
  bool get isLoading => _isLoading;

  Future<void> fetchRestaurants(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await apiService.getListOfRestaurants(context);
      _restaurants = Success(data.map((item) => Restaurant.fromJson(item)).toList());
    } catch (e) {
      _restaurants = Error(e.toString());
      CustomSnackbar.showSnackbar(context, 'Failed to load restaurants: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRestaurantDetail(String restaurantId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      _restaurantDetail = await apiService.getRestaurantDetail(restaurantId, context);
    } catch (e) {
      CustomSnackbar.showSnackbar(context, 'Failed to fetch restaurant details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchRestaurants(String query, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await apiService.searchRestaurants(query, context);
      _restaurants = Success(data.map((item) => Restaurant.fromJson(item)).toList());
    } catch (e) {
      _restaurants = Error(e.toString());
      CustomSnackbar.showSnackbar(context, 'Failed to search restaurants: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
