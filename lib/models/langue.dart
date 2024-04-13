class Langue {
  String? keyLangue;
  String? nom;

  Langue({this.keyLangue, this.nom});

  Langue.fromJson(Map<String, dynamic> json) {
    keyLangue = json['key_langue'];
    nom = json['nom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_langue'] = keyLangue;
    data['nom'] = nom;
    return data;
  }
}
