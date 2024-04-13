import 'package:kondjigbale/models/menu.dart';

class MenuResponse {
  String? status;
  String? message;
  List<Menu>? information;

  MenuResponse({this.status, this.message, this.information});

  MenuResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['information'] != null) {
      information = <Menu>[];
      json['information'].forEach((v) {
        information!.add(Menu.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (information != null) {
      data['information'] = information!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
