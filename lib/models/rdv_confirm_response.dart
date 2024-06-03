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
        ? Confirm.fromJson(json['information'])
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
