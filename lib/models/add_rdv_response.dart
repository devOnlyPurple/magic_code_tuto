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
        ? Rdv.fromJson(json['rendez_vous'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['amount'] = amount;
    if (rendezVous != null) {
      data['rendez_vous'] = rendezVous!.toJson();
    }
    return data;
  }
}
