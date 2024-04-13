class Expert {
  String? keyExpert;
  String? name;
  String? pseudo;
  String? email;
  String? telephone;
  String? specialite;
  String? photo;

  Expert(
      {this.keyExpert,
      this.name,
      this.pseudo,
      this.email,
      this.telephone,
      this.specialite,
      this.photo});

  Expert.fromJson(Map<String, dynamic> json) {
    keyExpert = json['key_expert'];
    name = json['name'];
    pseudo = json['pseudo'];
    email = json['email'];
    telephone = json['telephone'];
    specialite = json['specialite'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_expert'] = keyExpert;
    data['name'] = name;
    data['pseudo'] = pseudo;
    data['email'] = email;
    data['telephone'] = telephone;
    data['specialite'] = specialite;
    data['photo'] = photo;
    return data;
  }
}
