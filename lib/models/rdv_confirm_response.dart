import 'package:kondjigbale/models/confirm.dart';

class Confirm_rdv {
  String? status;
  String? message;
  Confirm? information;

  Confirm_rdv({this.status, this.message, this.information});

  Confirm_rdv.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? new Confirm.fromJson(json['information'])
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
