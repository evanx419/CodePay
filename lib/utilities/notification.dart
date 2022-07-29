import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class myNotification {
  static final _notificcaton = FlutterLocalNotificationsPlugin();
_notificationDetails()async{
  return NotificationDetails(
    android: AndroidNotificationDetails(
      'channel id',
      'channel name',
      // 'channel description',
      importance: Importance.max,
      
    ),
    iOS: IOSNotificationDetails()
  );


}

Future showNotification(
  final int id,
  final String? title,
  final String? body,
  final String? payload,)async{
 await _notificcaton.show(id, title, body,await _notificationDetails(),);
}


}


List hint = [
  "Your only job on the flight will be to kick back, relax, and enjoy the ride.",
  "The G-forces experienced on launch and reentry are not as intense as you might expect.",
  "To prep for weightlessness, you should book a zero-G flight.",
  "Learning how to scuba dive is good weightlessness training, too.",
  "Come up with a game plan for your few minutes in space.",
  "When you get into zero-G, you might feel a little dizzy.",
  "If you’re spending a few days in space, be prepared for some bumps and bruises.",
  "If you’re going to do a spacewalk, the stakes are much higher for you and your crew.",
  "If you’re in a capsule, be prepared for a bumpy landing.",

];
