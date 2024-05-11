import 'rdv.dart';

class CancelRdv {
  String? status;
  String? message;
  Rdv? information;

  CancelRdv({this.status, this.message, this.information});

  CancelRdv.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? new Rdv.fromJson(json['information'])
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
