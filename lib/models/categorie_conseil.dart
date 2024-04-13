class CategorieConseil {
  String? keyCategorie;
  String? nom;
  String? image;
  int? id;
  int? status;

  CategorieConseil(
      {this.keyCategorie, this.nom, this.image, this.id, this.status});

  CategorieConseil.fromJson(Map<String, dynamic> json) {
    keyCategorie = json['key_categorie'];
    nom = json['nom'];
    image = json['image'];
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_categorie'] = keyCategorie;
    data['nom'] = nom;
    data['image'] = image;
    data['id'] = id;
    data['status'] = status;
    return data;
  }
}
