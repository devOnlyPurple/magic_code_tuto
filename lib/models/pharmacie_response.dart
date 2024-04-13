import 'package:kondjigbale/models/Pharmacie.dart';

class PharmaciesResponse {
  String? status;
  String? message;
  Pharmacie? information;

  PharmaciesResponse({this.status, this.message, this.information});

  PharmaciesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? Pharmacie.fromJson(json['information'])
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
