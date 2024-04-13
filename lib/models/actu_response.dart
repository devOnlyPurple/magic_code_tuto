import 'package:kondjigbale/models/actualite.dart';

class ActuResponse {
  String? status;
  String? message;
  List<Actualite>? information;

  ActuResponse({this.status, this.message, this.information});

  ActuResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['information'] != null) {
      information = <Actualite>[];
      json['information'].forEach((v) {
        information!.add(Actualite.fromJson(v));
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

class Categories {
  String? keyCategorie;
  String? nom;

  Categories({this.keyCategorie, this.nom});

  Categories.fromJson(Map<String, dynamic> json) {
    keyCategorie = json['key_categorie'];
    nom = json['nom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_categorie'] = keyCategorie;
    data['nom'] = nom;
    return data;
  }
}
