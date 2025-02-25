import 'package:dio/dio.dart';
import 'package:restaurant_app_dicoding/services/my_workmanager.dart';
import 'package:restaurant_app_dicoding/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';
import 'dart:math';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NotificationService().init();

    final dio = Dio();
    final restaurants = await dio.get('https://restaurant-api.dicoding.dev/list');
    final randomRestaurant = restaurants.data['restaurants'][Random().nextInt(restaurants.data['restaurants'].length)];
    final restaurantName = randomRestaurant['name'];
    final restaurantAddress = randomRestaurant['city'];

    final now = DateTime.now();
    final scheduledHour = inputData!['hour'];
    final scheduledMinute = inputData['minute'];
    final scheduledTime = DateTime(now.year, now.month, now.day, scheduledHour, scheduledMinute);

    if (now.isAfter(scheduledTime) && now.isBefore(scheduledTime.add(Duration(hours: 1)))) {
      await NotificationService().showNotification(
        restaurantName: restaurantName,
        restaurantAddress: restaurantAddress,
      );
    }

    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager]) : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runOneOffTask(int hour, int minute) async {
    await _workmanager.registerOneOffTask(
      MyWorkmanager.oneOff.uniqueName,
      MyWorkmanager.oneOff.taskName,
      constraints: Constraints(networkType: NetworkType.connected),
      initialDelay: const Duration(seconds: 5),
      inputData: {"hour": hour, "minute": minute},
    );
  }

  Future<void> runPeriodicTask(int hour, int minute) async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 16),
      initialDelay: Duration.zero,
      inputData: {"data": "This is a valid payload from periodic task workmanager", "hour": hour, "minute": minute},
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
