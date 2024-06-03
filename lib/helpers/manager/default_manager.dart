import 'package:hive/hive.dart';

import '../../models/local/default_data.dart';

class DataManager {
  static const String _boxName = 'defaultData';

  static void saveDefaultData(DefaultData data) {
    Box box = Hive.box(_boxName);
    box.put('data', data.toJson()); // Convertir en JSON pour stocker
  }

  static DefaultData? getDefaultData() {
    Box box = Hive.box(_boxName);
    Map<dynamic, dynamic>? jsonData = box.get('data');
    if (jsonData != null) {
      Map<String, dynamic> castedData = jsonData.cast<String, dynamic>();
      return DefaultData.fromJson(castedData);
    }
    return null;
  }

  static void updateLanguage(String newLanguage) {
    Box box = Hive.box(_boxName);
    Map<dynamic, dynamic>? jsonData = box.get('data');
    if (jsonData != null) {
      Map<String, dynamic> castedData = jsonData.cast<String, dynamic>();
      DefaultData data = DefaultData.fromJson(castedData);
      data.langue = newLanguage;
      saveDefaultData(data);
    }
  }
}
