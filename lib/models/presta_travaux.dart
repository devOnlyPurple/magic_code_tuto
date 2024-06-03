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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['titre'] = titre;
    data['lien_publication'] = lienPublication;
    data['annee_publication'] = anneePublication;
    return data;
  }
}