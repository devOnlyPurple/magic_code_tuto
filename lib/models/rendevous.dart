import 'package:kondjigbale/models/rdv.dart';


class RendeVous {
  List<Rdv>? current;
  List<Rdv>? past;

  RendeVous({this.current, this.past});

  RendeVous.fromJson(Map<String, dynamic> json) {
    if (json['current'] != null) {
      current = <Rdv>[];
      json['current'].forEach((v) {
        current!.add(Rdv.fromJson(v));
      });
    }
    if (json['past'] != null) {
      past = <Rdv>[];
      json['past'].forEach((v) {
        past!.add(Rdv.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (current != null) {
      data['current'] = current!.map((v) => v.toJson()).toList();
    }
    if (past != null) {
      data['past'] = past!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}