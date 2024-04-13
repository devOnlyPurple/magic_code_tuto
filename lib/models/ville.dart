class Ville {
  String? key;
  String? nom;

  Ville({this.key, this.nom});

  Ville.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    nom = json['nom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['nom'] = nom;
    return data;
  }
}
