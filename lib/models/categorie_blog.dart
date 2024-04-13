class CategorieBlog {
  String? keyCategorie;
  String? nom;
  int? id;
  int? status;

  CategorieBlog({this.keyCategorie, this.nom, this.id, this.status});

  CategorieBlog.fromJson(Map<String, dynamic> json) {
    keyCategorie = json['key_categorie'];
    nom = json['nom'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_categorie'] = keyCategorie;
    data['nom'] = nom;
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}
