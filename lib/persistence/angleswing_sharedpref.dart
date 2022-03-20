import 'dart:ffi';

import 'package:shared_preferences/shared_preferences.dart';


class AngleswingSharedPreferences{
  late SharedPreferences prefs;


  initialize()async {
     prefs = await SharedPreferences.getInstance();

  }
   final  String LOCATIONS = 'locations';




  void setLocations (String locations){
    if (prefs!=null){
      prefs.setString(LOCATIONS, locations);
    }

  }

  String getLocations(){
    return prefs.getString(LOCATIONS);
  }





}
final preferences = AngleswingSharedPreferences();