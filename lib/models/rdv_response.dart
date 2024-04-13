
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
        ? new RendeVous.fromJson(json['information'])
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















