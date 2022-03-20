import 'dart:convert';

class Location {
  Location(
     this.latitude,
     this.longitude,
  );


  late double latitude ;
  late double longitude;
  factory Location.fromJson(Map<String, dynamic> jsonData) {
    return Location(
 jsonData['latitude'],
  jsonData['longitude'],
    );
  }

  static Map<String, dynamic> toMap(Location location) => {
    'latitude': location.latitude,
    'longitude': location.longitude,
  };

  static String encode(List<Location> locations) => json.encode(
    locations
        .map<Map<String, dynamic>>((location) => Location.toMap(location))
        .toList(),
  );

  static List<Location> decode(String locations) =>
      (json.decode(locations) as List<dynamic>)
          .map<Location>((item) => Location.fromJson(item))
          .toList();

  }