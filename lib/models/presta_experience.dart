class Experiences {
  String? periode;
  String? denominationPoste;
  String? formationSanitaire;

  Experiences({this.periode, this.denominationPoste, this.formationSanitaire});

  Experiences.fromJson(Map<String, dynamic> json) {
    periode = json['Periode'];
    denominationPoste = json['denomination_poste'];
    formationSanitaire = json['formation_sanitaire'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Periode'] = this.periode;
    data['denomination_poste'] = this.denominationPoste;
    data['formation_sanitaire'] = this.formationSanitaire;
    return data;
  }
}