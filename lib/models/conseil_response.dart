import 'package:kondjigbale/models/conseil.dart';

class ConseilResponse {
  String? status;
  String? message;
  List<Conseil>? information;

  ConseilResponse({this.status, this.message, this.information});

  ConseilResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['information'] != null) {
      information = <Conseil>[];
      json['information'].forEach((v) {
        information!.add(Conseil.fromJson(v));
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
