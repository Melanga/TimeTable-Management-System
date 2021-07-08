import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

  Future<void> setDailyNotifications(List<String> subjectList, Map <String, String>subjectMap) async{
    QuerySnapshot data = await FirebaseFirestore.instance.collection('SubjectTimeSlot').where('course_Code', whereIn: subjectList).get();
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
      _scheduleWeeklyNotification(dayList[day], notificationTitle, notificationBody);
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

  Future<void> _scheduleWeeklyNotification(int day, String notificationTitle, String notificationBody) async {
    await notificationsPlugin.zonedSchedule(
        day,
        notificationTitle,
        notificationBody,
        _nextInstanceOfWeek(day),
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

  tz.TZDateTime _nextInstanceOfWeek(day) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTenAM();
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return now;
  }

}