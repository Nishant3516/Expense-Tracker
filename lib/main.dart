import 'package:expensetracker/features/expense/data/models/expense_model.dart';
import 'package:expensetracker/features/expense/presentation/pages/expenses_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and open your box.
  await Hive.initFlutter((await getApplicationDocumentsDirectory()).path);
  Hive.registerAdapter(ExpenseModelAdapter());
  await Hive.openBox<ExpenseModel>('expenses');

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await scheduleDailyReminder();

  runApp(const ProviderScope(child: MyApp()));
}

Future<void> scheduleDailyReminder() async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'daily_reminder_channel_id',
    'Daily Reminder',
    channelDescription: 'Channel for Daily Reminder',
    importance: Importance.high,
    priority: Priority.high,
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await FlutterLocalNotificationsPlugin().periodicallyShow(
    0,
    'Expense Tracker',
    'Remember to record your daily expenses!',
    RepeatInterval.daily,
    platformChannelSpecifics,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Expense Tracking App',
      home: ExpensesListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
