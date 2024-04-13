import 'package:kondjigbale/models/une_adresse.dart';

class AdresseResponse {
  String? status;
  String? message;
  List<Adresse>? information;

  AdresseResponse({this.status, this.message, this.information});

  AdresseResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['information'] != null) {
      information = <Adresse>[];
      json['information'].forEach((v) {
        information!.add(Adresse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (information != null) {
      data['information'] = information!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
