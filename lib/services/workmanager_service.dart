import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_dicoding/providers/theme_provider.dart';
import 'package:restaurant_app_dicoding/services/my_workmanager.dart';
import 'package:restaurant_app_dicoding/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Initialize NotificationService
    await NotificationService().init();

    // Schedule daily notification
    await NotificationService().scheduleDailyNotification(id: 0, time: inputData!['time']);
    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager]) : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runOneOffTask(BuildContext context) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    final String timeofDay = themeProvider.notificationTime.format(context);

    await _workmanager.registerOneOffTask(
      MyWorkmanager.oneOff.uniqueName,
      MyWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "time": timeofDay,
      },
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
