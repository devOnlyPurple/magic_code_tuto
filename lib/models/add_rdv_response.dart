import 'package:kondjigbale/models/rdv.dart';

class Add_rdv {
  String? status;
  String? message;
  String? amount;
  Rdv? rendezVous;

  Add_rdv({this.status, this.message, this.amount, this.rendezVous});

  Add_rdv.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    amount = json['amount'];
    rendezVous = json['rendez_vous'] != null
        ? new Rdv.fromJson(json['rendez_vous'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['amount'] = this.amount;
    if (this.rendezVous != null) {
      data['rendez_vous'] = this.rendezVous!.toJson();
    }
    return data;
  }
}
