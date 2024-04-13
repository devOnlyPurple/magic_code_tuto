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
        information!.add(new Prestataire.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.information != null) {
      data['information'] = this.information!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
