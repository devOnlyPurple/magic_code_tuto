class TypeRdv {
  String? keyTypeRendezVous;
  String? nom;
  String? description;

  TypeRdv({this.keyTypeRendezVous, this.nom, this.description});

  TypeRdv.fromJson(Map<String, dynamic> json) {
    keyTypeRendezVous = json['key_type_rendez_vous'];
    nom = json['nom'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_type_rendez_vous'] = keyTypeRendezVous;
    data['nom'] = nom;
    data['description'] = description;
    return data;
  }
}
