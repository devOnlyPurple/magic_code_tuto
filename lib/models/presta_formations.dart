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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['annee_obtention'] = this.anneeObtention;
    data['denomination_diplome'] = this.denominationDiplome;
    data['denomination_ecole'] = this.denominationEcole;
    return data;
  }
}