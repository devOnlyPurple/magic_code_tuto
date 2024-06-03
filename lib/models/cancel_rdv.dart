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
        ? Rdv.fromJson(json['information'])
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
