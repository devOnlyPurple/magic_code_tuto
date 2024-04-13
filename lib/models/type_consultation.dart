class TypeConsultation {
  String? keyTypeConsultation;
  String? nom;

  TypeConsultation({this.keyTypeConsultation, this.nom});

  TypeConsultation.fromJson(Map<String, dynamic> json) {
    keyTypeConsultation = json['key_type_consultation'];
    nom = json['nom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_type_consultation'] = keyTypeConsultation;
    data['nom'] = nom;
    return data;
  }
}
