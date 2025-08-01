import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false; // Changed from final to allow modification
  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(initializationSettings);

    await _createNotificationChannel();
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      print('Error getting local timezone: $e');
      tz.setLocalLocation(tz.getLocation('Etc/UTC')); // Fallback to UTC
    }

    _isInitialized = true; // Set to true after initialization
    print('NotificationService initialized with channel');
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'channel_name',
      description:
          'channel_description', // Use 'description' instead of 'channel_description'
      importance: Importance.max,
      playSound: true,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
      );
      try {
        await intent.launch();
      } on PlatformException catch (e) {
        print('Could not open exact alarm settings: $e');
        // Fallback: Open app settings if exact alarm intent fails
        final appSettingsIntent = AndroidIntent(
          action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
          data:
              'package:com.example.academikit', // Replace with your package name
        );
        await appSettingsIntent.launch();
      }
    }
  }

  Future<bool> hasExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;
      return status.isGranted;
    }
    return true;
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) {
      await init();
    }
    print('Showing notification: $title - $body');
    await _notificationsPlugin.show(id, title, body, _notificationDetails());
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    // Correctly use the provided scheduledDate
    final scheduledDateTZ = tz.TZDateTime.from(scheduledDate, tz.local);
    final usedDate = tz.TZDateTime(
      tz.local,
      scheduledDateTZ.year,
      scheduledDateTZ.month,
      scheduledDateTZ.day,
      0,
    );
    // Ensure the scheduled date is in the future
    if (scheduledDateTZ.isBefore(tz.TZDateTime.now(tz.local))) {
      print('Scheduled date is in the past. Not scheduling notification.');
      return;
    }

    print('Scheduling notification for $scheduledDateTZ');

    // Check and request exact alarm permission if necessary
    bool exactAlarmPermission = await hasExactAlarmPermission();
    if (!exactAlarmPermission) {
      print(
        'Exact alarm permission not granted. Falling back to inexact schedule.',
      );
    }

    await _notificationsPlugin.zonedSchedule(
      id, // Use the provided ID
      title,
      body,
      usedDate,
      _notificationDetails(),
      androidScheduleMode: exactAlarmPermission
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> getPendingNotifications() async {
    if (!_isInitialized) {
      await init();
    }
    var pendingNotificationRequests = await _notificationsPlugin
        .pendingNotificationRequests();
    for (var notification in pendingNotificationRequests) {
      print('''
    ID: ${notification.id}
    Title: ${notification.title}
    Body: ${notification.body}
    Payload: ${notification.payload}s
    ''');
    }
  }
}
