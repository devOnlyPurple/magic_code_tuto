import 'package:kondjigbale/models/user.dart';

class LoginResponse {
  String? status;
  String? message;
  User? information;

  LoginResponse({this.status, this.message, this.information});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['information'] != null) {
      information = User.fromJson(json['information']);
    }
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
