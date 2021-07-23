import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class DailyNotification{
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  Map <String, int>dayList = {
    "Sunday" : DateTime.sunday,
    "Monday" : DateTime.monday,
    "Tuesday" : DateTime.tuesday,
    "Wednesday" : DateTime.wednesday,
    "Thursday" : DateTime.thursday,
    "Friday" : DateTime.friday,
    "Saturday" : DateTime.saturday};
  List <String>weekDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  //List <String>weekDays = ["Monday"];

  // This function set daily briefing notification
  Future<void> setDailyNotifications(List<String> subjectList, Map <String, String>subjectMap) async{
    QuerySnapshot data = await FirebaseFirestore.instance.collection('SubjectTimeSlot').where('course_Code', whereIn: subjectList).get();
    final prefs = await SharedPreferences.getInstance();
    TimeOfDay initTime = new TimeOfDay(hour: 7, minute: 0);
    String timeString = prefs.getString("isNotificationTime");
    if (timeString.isNotEmpty){
      initTime = TimeOfDay(
          hour: int.parse(timeString.substring(0,2)),
          minute: int.parse(timeString.substring(5,7)));
    }
    weekDays.forEach((day) {
      String notificationTitle = "Your " + day + " Subjects:";
      //var notificationTime = tz.TZDateTime.now(tz.local).add(Duration(seconds: 5));
      String notificationBody = "";
      data.docs.forEach((timeSlot) {
        if(day == timeSlot.data()['day']){
          notificationBody = notificationBody + subjectMap[timeSlot.data()['course_Code']] +
              ": - " + timeSlot.data()['start_Time'] + " to " + timeSlot.data()['end_Time'] +
              " in " + timeSlot.data()['location'] +"////";
        }
      });
      _scheduleWeeklyNotification(dayList[day], notificationTitle, notificationBody, initTime);
      /*notificationsPlugin.zonedSchedule(
          0,
          notificationTitle,
          notificationBody,
          notificationTime,
          NotificationDetails(
            android: AndroidNotificationDetails('channel id', 'channel name', 'channel description')
          ),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true);*/
    });
  }

  Future<void> cancelDailyNotifications() async{
    dayList.values.forEach((element) async{
      await notificationsPlugin.cancel(element);
    });
    print("Notifications Were Cancelled");
  }

  Future<void> setTaskNotifications(List<String> subjectList, Map <String, String>subjectMap) async {
    QuerySnapshot subjectTasks = await FirebaseFirestore.instance.collection('SubjectTask').where('course_Code', whereIn: subjectList).orderBy('course_Code', descending: true).get();
    int notificationId = 100;
    DateTime today = DateTime.now();
    subjectTasks.docs.forEach((subjectTask) {
      DateTime taskDate = DateTime.parse(subjectTask.data()['date']);
      if(taskDate.isAfter(today)){
        String notificationTitle = subjectMap[subjectTask.data()['course_Code']] + ": " + subjectTask.data()['title'] + " on " + subjectTask.data()['date'];
        String notificationBody = subjectTask.data()['description'];
        String time = subjectTask.data()['time'];
        DateTime notificationDate = taskDate.add(Duration(
            hours: int.parse(time.substring(0,2)),
            minutes: int.parse(time.substring(6,7)))).subtract(Duration(days: 1));
        _scheduleTaskNotification(notificationId, notificationTitle, notificationBody, notificationDate);
        notificationId = notificationId + 1;
      }
    });
  }


  Future<void> _scheduleTaskNotification(int id, String notificationTitle, String notificationBody, DateTime date) async {
    await notificationsPlugin.zonedSchedule(
        id,
        notificationTitle,
        notificationBody,
        tz.TZDateTime.from(date, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task notification channel id',
            'task notification channel name',
            'task notification description'),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  // This method initialize the local notification package
  void initializeSettings() async{
    var initializeAndroid = AndroidInitializationSettings('app_logo');
    var initializeIos = IOSInitializationSettings(requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
    );
    var initializeSettings = InitializationSettings(
      android: initializeAndroid,
      iOS: initializeIos
    );
    notificationsPlugin.initialize(initializeSettings);
  }

  Future<void> _scheduleWeeklyNotification(int day, String notificationTitle, String notificationBody, time) async {
    await notificationsPlugin.zonedSchedule(
        day,
        notificationTitle,
        notificationBody,
        _nextInstanceOfWeek(day, time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'weekly notification channel id',
              'weekly notification channel name',
              'weekly notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  tz.TZDateTime _nextInstanceOfWeek(day, time) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM(time);
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTenAM(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print("Notifications Were set at " + time.toString());
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, 0,0,0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

}