
import 'package:kondjigbale/models/rendevous.dart';

class RdvResponse {
  String? status;
  String? message;
  RendeVous? information;

  RdvResponse({this.status, this.message, this.information});

  RdvResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? RendeVous.fromJson(json['information'])
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















