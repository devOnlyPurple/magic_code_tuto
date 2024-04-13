class Adresse {
  String? userToken;
  int? userId;
  String? keyAdresse;
  String? nomAdresse;
  String? longitude;
  String? latitude;
  String? adresseLink;
  String? description;

  Adresse(
      {this.userToken,
      this.userId,
      this.keyAdresse,
      this.nomAdresse,
      this.longitude,
      this.latitude,
      this.adresseLink,
      this.description});

  Adresse.fromJson(Map<String, dynamic> json) {
    userToken = json['user_token'];
    userId = json['user_id'];
    keyAdresse = json['key_adresse'];
    nomAdresse = json['nom_adresse'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    adresseLink = json['adresse_link'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_token'] = userToken;
    data['user_id'] = userId;
    data['key_adresse'] = keyAdresse;
    data['nom_adresse'] = nomAdresse;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['adresse_link'] = adresseLink;
    data['description'] = description;
    return data;
  }
}
