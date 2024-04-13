import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:kondjigbale/classe/device_infos.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceAllInfoService {
  Future<DeviceAllInfo> getDeviceLocationAndInfo() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    /*final firebaseMessaging = FirebaseMessaging.instance;
    String? fcm = await firebaseMessaging.getToken();*/

    String fcm = "";

    double latitude = position.latitude;
    double longitude = position.longitude;

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceId = "";
    String deviceName = "";

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.name!;
      deviceId = iosInfo.identifierForVendor!;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model;
      deviceId = androidInfo.id;
    }

    DeviceAllInfo locationInfo = DeviceAllInfo(
        latitude: latitude,
        longitude: longitude,
        deviceId: deviceId,
        deviceName: deviceName,
        fcm: fcm);

    return locationInfo;
  }

  Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      // La permission de localisation a été accordée
    } else if (status.isDenied) {
      // L'utilisateur a refusé la permission de localisation
    } else if (status.isPermanentlyDenied) {
      // L'utilisateur a refusé la permission de localisation et a coché "Ne plus demander"
      // Vous pouvez ouvrir les paramètres de l'application pour que l'utilisateur puisse activer la permission manuellement
    }
  }
}
