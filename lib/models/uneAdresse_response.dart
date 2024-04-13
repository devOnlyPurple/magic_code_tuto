import 'package:kondjigbale/models/une_adresse.dart';

class UneAdresseResponse {
  String? status;
  String? message;
  Adresse? information;

  UneAdresseResponse({this.status, this.message, this.information});

  UneAdresseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? Adresse.fromJson(json['information'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (information != null) {
      data['information'] = information!.toJson();
    }
    return data;
  }
}
