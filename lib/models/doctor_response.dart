import 'package:kondjigbale/models/prestataire.dart';

class DoctorResponse {
  String? status;
  String? message;
  List<Prestataire>? information;

  DoctorResponse({this.status, this.message, this.information});

  DoctorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['information'] != null) {
      information = <Prestataire>[];
      json['information'].forEach((v) {
        information!.add(Prestataire.fromJson(v));
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
