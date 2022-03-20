import 'dart:async';

import 'package:angel_swing/model/areas.dart';
import '../model/location.dart';
import 'api_provider.dart';

class LocationRepo {
  final apiProvider = ApiProvider();
  Future<List<Location>> getLocations ()  async{
    final response = await apiProvider.getLocations();
    List<Location> locations = [];
    // this is done because the json response cannot be converted in dart model
    String s =  response.toString();
    s = s.replaceAll(new RegExp(r'[^0-9.,$,]'),''); // '23'

    final splitNames= s.split(',');
    for (int i = 0; i < splitNames.length; i+=2){
      Location location = Location(0,0);
      location.latitude = double.parse(splitNames[i]);
      if(i+1<splitNames.length)
        location.longitude = double.parse(splitNames[i+1]);

      locations.add(location);

    }
    
    return locations;

  }




}
