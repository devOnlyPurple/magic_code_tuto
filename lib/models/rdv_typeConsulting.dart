class TypeConsultations {
  String? keyTypeConsultation;
  String? denominationTypeConsultation;
  String? tarif;

  TypeConsultations(
      {this.keyTypeConsultation,
      this.denominationTypeConsultation,
      this.tarif});

  TypeConsultations.fromJson(Map<String, dynamic> json) {
    keyTypeConsultation = json['key_type_consultation'];
    denominationTypeConsultation = json['denomination_type_consultation'];
    tarif = json['tarif'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key_type_consultation'] = this.keyTypeConsultation;
    data['denomination_type_consultation'] = this.denominationTypeConsultation;
    data['tarif'] = this.tarif;
    return data;
  }
}
