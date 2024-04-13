
class Specialite {
  String? keySpecialite;
  String? nom;

  Specialite({this.keySpecialite, this.nom});

  Specialite.fromJson(Map<String, dynamic> json) {
    keySpecialite = json['key_specialite'];
    nom = json['nom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_specialite'] = keySpecialite;
    data['nom'] = nom;
    return data;
  }
}
