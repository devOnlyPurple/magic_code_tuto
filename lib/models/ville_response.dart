import 'package:kondjigbale/models/ville.dart';

class VilleResponse {
  String? status;
  String? message;
  List<Ville>? information;

  VilleResponse({this.status, this.message, this.information});

  VilleResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['information'] != null) {
      information = <Ville>[];
      json['information'].forEach((v) {
        information!.add(Ville.fromJson(v));
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
