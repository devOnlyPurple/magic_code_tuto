class Travaux {
  String? titre;
  String? lienPublication;
  int? anneePublication;

  Travaux({this.titre, this.lienPublication, this.anneePublication});

  Travaux.fromJson(Map<String, dynamic> json) {
    titre = json['titre'];
    lienPublication = json['lien_publication'];
    anneePublication = json['annee_publication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titre'] = this.titre;
    data['lien_publication'] = this.lienPublication;
    data['annee_publication'] = this.anneePublication;
    return data;
  }
}