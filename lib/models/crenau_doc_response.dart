import 'package:kondjigbale/models/creneau.dart';

class NicheDoctorResponse {
  String? status;
  String? message;
  Component? information;

  NicheDoctorResponse({this.status, this.message, this.information});

  NicheDoctorResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? Component.fromJson(json['information'])
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

class Component {
  int? dureeConsultation;
  String? amount;
  List<Creneau>? creneau;

  Component({this.dureeConsultation, this.amount, this.creneau});

  Component.fromJson(Map<String, dynamic> json) {
    dureeConsultation = json['duree_consultation'];
    amount = json['amount'];
    if (json['creneau'] != null) {
      creneau = <Creneau>[];
      json['creneau'].forEach((v) {
        creneau!.add(Creneau.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['duree_consultation'] = dureeConsultation;
    data['amount'] = amount;
    if (creneau != null) {
      data['creneau'] = creneau!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
