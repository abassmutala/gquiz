import 'dart:io';

// import 'package:bookiema/constants/route_names.dart';
// import 'package:bookiema/locator.dart';
// import 'package:bookiema/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  // final NavigationService _navigationService = locator<NavigationService>();

  Future initialise() async {
    if (Platform.isIOS) {
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
      } else {
        debugPrint('User declined or has not accepted permission');
      }
    }

    _fcm.getToken().then((value) => debugPrint(value));

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      debugPrint("message recieved");
      debugPrint(event.notification.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint('Message clicked!');
      _serialiseAndNavigate(message);
    });
  }

  void _serialiseAndNavigate(RemoteMessage message) {
    var notificationData = message.data;
    var view = notificationData['view'];

    // if (view != null) {
    //   if (view == 'view_bookings') {
    //     _navigationService.navigateTo(myBookingsRoute);
    //   }
    // }
  }
}
