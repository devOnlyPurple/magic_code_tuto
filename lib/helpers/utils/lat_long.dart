import 'package:geolocator/geolocator.dart';

import '../../models/local/position_lat_long.dart';

class PositionAllInfo {
  Future<PositionLatLong> getDevicePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double latitude = position.latitude;
    double longitude = position.longitude;

    PositionLatLong positionLatLong = PositionLatLong(
      latitude: latitude.toString(),
      longitude: longitude.toString(),
    );

    return positionLatLong;
  }
}
