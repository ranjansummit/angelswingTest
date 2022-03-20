/// locations : [[37.56755685,126.97328373],[37.56722338,126.98351298],[37.56269872,126.97860143]]

class Areas {
  late List<List<double>> _locations ;
  Areas({
      required List<List<double>> locations,}){
    _locations = locations;
}

  Areas.fromJson(dynamic json) {
    _locations = json['locations'] != null ? json['locations'].cast<double>() : [];
  }

  List<List<double>> get locations => _locations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['locations'] = _locations;
    return map;
  }

}