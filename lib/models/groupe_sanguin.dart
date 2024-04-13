class GroupeSanguin {
  String? keyGroupeSanguin;
  String? nom;

  GroupeSanguin({this.keyGroupeSanguin, this.nom});

  GroupeSanguin.fromJson(Map<String, dynamic> json) {
    keyGroupeSanguin = json['key_groupe_sanguin'];
    nom = json['nom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_groupe_sanguin'] = keyGroupeSanguin;
    data['nom'] = nom;
    return data;
  }
}
