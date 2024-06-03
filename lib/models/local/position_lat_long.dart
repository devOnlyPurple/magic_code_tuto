class PositionLatLong {
  String? longitude;
  String? latitude;

  PositionLatLong({this.longitude, this.latitude});

  PositionLatLong.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}
