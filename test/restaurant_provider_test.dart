import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app_dicoding/providers/restaurant_provider.dart';
import 'package:restaurant_app_dicoding/services/api_services.dart';
import 'package:restaurant_app_dicoding/models/restaurant_model.dart';
import 'package:restaurant_app_dicoding/models/resource.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi;

  late RestaurantProvider provider;
  late MockApiService mockApiService;

  setUp(() {
    mockApiService = MockApiService();
    provider = RestaurantProvider()..apiService = mockApiService;
  });

  test('Initial state of the provider defined', () {
    expect(provider.restaurants, isA<Loading>());
    expect(provider.isLoading, false);
    expect(provider.favorites, isEmpty);
  });

  test('return a list of restaurants when the API data fetch is successful', () async {
    final restaurantList = [
      {'id': '1', 'name': 'Restaurant 1', 'city': 'City 1', 'description': 'Description 1'},
      {'id': '2', 'name': 'Restaurant 2', 'city': 'City 2', 'description': 'Description 2'},
    ];

    when(() => mockApiService.getListOfRestaurants(null)).thenAnswer((_) async => restaurantList);

    await provider.fetchRestaurants(null);

    expect(provider.restaurants, isA<Success<List<Restaurant>>>());
    expect((provider.restaurants as Success<List<Restaurant>>).data.length, restaurantList.length);
    expect(provider.isLoading, false);
  });

  test('return an error when the API data fetch fails', () async {
    final errorMessage = 'Exception: Failed to load restaurants';

    when(() => mockApiService.getListOfRestaurants(null)).thenThrow(Exception('Failed to load restaurants'));

    await provider.fetchRestaurants(null);

    expect(provider.restaurants, isA<Error>());
    expect((provider.restaurants as Error).message, errorMessage);
    expect(provider.isLoading, false);
  });
}

class MockBuildContext extends Mock implements BuildContext {}
