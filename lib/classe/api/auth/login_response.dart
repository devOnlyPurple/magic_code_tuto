import 'package:kondjigbale/classe/api/auth/user_response.dart';

class ResponseLogin {
  String? status;
  String? message;
  UserResponse? information;

  ResponseLogin({this.status, this.message, this.information});

  ResponseLogin.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? UserResponse.fromJson(json['information'])
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
