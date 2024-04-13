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
        ? new Component.fromJson(json['information'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.information != null) {
      data['information'] = this.information!.toJson();
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
        creneau!.add(new Creneau.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['duree_consultation'] = this.dureeConsultation;
    data['amount'] = this.amount;
    if (this.creneau != null) {
      data['creneau'] = this.creneau!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
