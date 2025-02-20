import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermission(BuildContext context) async {
    final bool? notificationGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    if (notificationGranted == null || !notificationGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification permission is required to show lunch notifications.')),
      );
    }
    final bool? scheduleGranted = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    if (scheduleGranted == null || !scheduleGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Alarms Notification permission is required to show lunch notifications.')),
      );
    }
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1',
      'lunch notification',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    // Fetch random restaurant name
    final dio = Dio();
    final restaurants = await dio.get('https://restaurant-api.dicoding.dev/list');
    final randomRestaurant = restaurants.data['restaurants'][Random().nextInt(restaurants.data['restaurants'].length)];
    final restaurantName = randomRestaurant['name'];
    final restaurantAddress = randomRestaurant['city'];

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Lunch Time Reminder',
      'It\'s almost lunch time! Check out $restaurantName at $restaurantAddress City.',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  tz.TZDateTime _nextScheduled(
    TimeOfDay time,
  ) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String time,
    String channelId = "3",
    String channelName = "Schedule Notification",
  }) async {
    TimeOfDay scheduledTime = TimeOfDay(hour: int.parse(time.split(":")[0]), minute: int.parse(time.split(":")[1]));

    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    final datetimeSchedule = _nextScheduled(scheduledTime);

    // Fetch random restaurant name
    final dio = Dio();
    final restaurants = await dio.get('https://restaurant-api.dicoding.dev/list');
    final randomRestaurant = restaurants.data['restaurants'][Random().nextInt(restaurants.data['restaurants'].length)];
    final restaurantName = randomRestaurant['name'];
    final restaurantAddress = randomRestaurant['city'];

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Lunch Time Reminder',
      'It\'s almost lunch time! Check out $restaurantName at $restaurantAddress City.',
      datetimeSchedule,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
