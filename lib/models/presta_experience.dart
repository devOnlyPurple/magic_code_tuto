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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Periode'] = periode;
    data['denomination_poste'] = denominationPoste;
    data['formation_sanitaire'] = formationSanitaire;
    return data;
  }
}