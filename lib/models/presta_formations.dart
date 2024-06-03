class Formations {
  int? anneeObtention;
  String? denominationDiplome;
  String? denominationEcole;

  Formations(
      {this.anneeObtention, this.denominationDiplome, this.denominationEcole});

  Formations.fromJson(Map<String, dynamic> json) {
    anneeObtention = json['annee_obtention'];
    denominationDiplome = json['denomination_diplome'];
    denominationEcole = json['denomination_ecole'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['annee_obtention'] = anneeObtention;
    data['denomination_diplome'] = denominationDiplome;
    data['denomination_ecole'] = denominationEcole;
    return data;
  }
}