import 'package:kondjigbale/models/rdv.dart';

import 'package:kondjigbale/models/rdv_response.dart';

class RendeVous {
  List<Rdv>? current;
  List<Rdv>? past;

  RendeVous({this.current, this.past});

  RendeVous.fromJson(Map<String, dynamic> json) {
    if (json['current'] != null) {
      current = <Rdv>[];
      json['current'].forEach((v) {
        current!.add(new Rdv.fromJson(v));
      });
    }
    if (json['past'] != null) {
      past = <Rdv>[];
      json['past'].forEach((v) {
        past!.add(new Rdv.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.current != null) {
      data['current'] = this.current!.map((v) => v.toJson()).toList();
    }
    if (this.past != null) {
      data['past'] = this.past!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}