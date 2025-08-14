// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:reminder_application/UI/front_page.dart';

// FIX: Removed 'const' here, as FlutterLocalNotificationsPlugin is not a const constructor
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _configureLocalTimezone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await _configureLocalTimezone();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // This was already fixed in a previous step to be 'final'
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  // FIX: Changed 'const' to 'final' because it's initialized with a non-const value (initializationSettingsIOS)
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Reminder App',
      theme: ThemeData(
        primarySwatch: Colors.teal, // New primary color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FrontPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
