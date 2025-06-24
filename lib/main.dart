import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'utils/notification_helper.dart';

import 'screens/home_screen.dart';
import 'screens/water_tracker_screen.dart';
import 'screens/weight_tracker_screen.dart';
import 'screens/body_tracker_screen.dart';

import 'providers/water_provider.dart';
import 'providers/weight_provider.dart';
import 'providers/body_provider.dart';

// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  // // 🧨 TEMP: Delete existing DB (for development only)
  // final dbPath = await getDatabasesPath();
  // await deleteDatabase(join(dbPath, 'wellness_tracker.db'));

  await NotificationHelper.initialize(_handleNotificationTap);
  await NotificationHelper.scheduleWaterReminders();

  runApp(MyApp());
}

void _handleNotificationTap(String? payload) {
  if (payload == 'open_water_tracker') {
    navigatorKey.currentState?.pushNamed(WaterTrackerScreen.routeName);
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WaterProvider()..loadEntries()),
        ChangeNotifierProvider(create: (_) => WeightProvider()..loadEntries()),
        ChangeNotifierProvider(create: (_) => BodyProvider()..loadMeasurements()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Wellness Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(), // Your home
          WaterTrackerScreen.routeName: (context) => WaterTrackerScreen(),
          WeightTrackerScreen.routeName: (context) => WeightTrackerScreen(),
          BodyTrackerScreen.routeName: (context) => BodyTrackerScreen()
        },
      ),
    );
  }
}
