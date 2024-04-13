import 'package:kondjigbale/models/garde.dart';
import 'package:kondjigbale/models/pharmas.dart';

class Pharmacie {
  List<Pharmas>? pharmas;
  Garde? garde;

  Pharmacie({this.pharmas, this.garde, required String prenoms});

  Pharmacie.fromJson(Map<String, dynamic> json) {
    if (json['pharmas'] != null) {
      pharmas = <Pharmas>[];
      json['pharmas'].forEach((v) {
        pharmas!.add(Pharmas.fromJson(v));
      });
    }
    garde = json['garde'] != null ? Garde.fromJson(json['garde']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pharmas != null) {
      data['pharmas'] = pharmas!.map((v) => v.toJson()).toList();
    }
    if (garde != null) {
      data['garde'] = garde!.toJson();
    }
    return data;
  }
}
