import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kondjigbale/classe/device_infos.dart';

import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/utils/device_all_info.dart';

class Api {
  static get_default_datas(Map<String, String> datas) async {
    final FlutterLocalization localization = FlutterLocalization.instance;
    const storage = FlutterSecureStorage();
    late String currentLocale;

    DeviceAllInfo deviceAllInfo =
        await DeviceAllInfoService().getDeviceLocationAndInfo();
    final String? registrationId = await storage.read(key: 'instance_token');
    String lang = localization.currentLocale!.languageCode;
    String dIdentifiant = 'XOF';

    datas.addAll({
      "access_token": ACCESS_TOKEN,
      "c_identifiant": CANAL,
      "registration_id": '',
      "dv_identifiant": dIdentifiant,
      "lang": lang,
      "latMember": deviceAllInfo.latitude.toString(),
      "longMember": deviceAllInfo.longitude.toString(),
      "device_id": deviceAllInfo.deviceId,
      "device_name": deviceAllInfo.deviceName,
    });

    return datas;
  }
}
