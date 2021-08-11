import 'package:flutter/material.dart';
import 'package:flutter_intelij/screens/home/student_home_screen.dart';
import 'package:flutter_intelij/services/daily_notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tz.initializeTimeZones();
    DailyNotification dailyNotification= new DailyNotification();
    dailyNotification.initializeSettings();
  }
  @override
  Widget build(BuildContext context) {
    return StudentHomeScreen();
  }
}
