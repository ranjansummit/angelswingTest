
import 'package:angel_swing/persistence/angleswing_sharedpref.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

import '../model/location.dart';

class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();
  double latitude=27.431461;
  double longitude =85.034397;
  Geolocator geo = new Geolocator();
  List<Location> locations=[];
  factory NotificationService() {
    return _notificationService;
  }
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: null,
        macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: null);

  }



  Future<void> show () async {
    bool serviceEnabled;
    LocationPermission permission;
    Position? currentposition;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print( 'Location Service is disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always) {
       currentposition = await Geolocator.getCurrentPosition();
    }
      AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
        'channel ID',
        'channel name',
        'channel description',
        playSound: true,
        priority: Priority.high,
        importance: Importance.high,
      );
      NotificationDetails platformChannelSpecifics =
      NotificationDetails(
        android: _androidNotificationDetails,
      );

      if(currentposition!=null){
        final String locationString = await preferences.getLocations();
        double testdistance = await Geolocator.distanceBetween(
            latitude, longitude, currentposition.latitude, currentposition.longitude);

        if (locationString != null) {
          locations = Location.decode(locationString);

          for (Location l in locations) {
            double distanceInMeters = await Geolocator.distanceBetween(
                l.latitude, l.longitude, currentposition.latitude, currentposition.longitude);


            if (distanceInMeters <= 5) {
              await flutterLocalNotificationsPlugin.show(
                0,
                'Near Marked Location',
                'latitude : ${l.latitude} \n longitude :${l.longitude}',
                platformChannelSpecifics,
                payload: 'Notification Payload',
              );
            }
          }
          if (kDebugMode) {
            if (testdistance <= 5) {
              await flutterLocalNotificationsPlugin.show(
                0,
                'Near Marked Location',
                'latitude : ${latitude} \n longitude :${longitude}',
                platformChannelSpecifics,
                payload: 'Notification Payload',
              );
            }
          }
        }
      }


  }
  NotificationService._internal();

}