class UserResponse {
  String? nom;
  String? prenoms;
  String? username;
  String? token;
  String? adresse;
  String? email;
  int? paysId;
  String? paysKey;
  String? paysName;
  String? photo;
  int? typeUserId;
  String? typeUserKey;
  String? typeUserName;
  String? dateNaissance;
  String? sexeKey;
  String? sexeName;
  String? deviseKey;
  String? deviseName;
  String? deviseAbreg;
  int? inscriptionPresta;

  UserResponse(
      {this.nom,
      this.prenoms,
      this.username,
      this.token,
      this.adresse,
      this.email,
      this.paysId,
      this.paysKey,
      this.paysName,
      this.photo,
      this.typeUserId,
      this.typeUserKey,
      this.typeUserName,
      this.dateNaissance,
      this.sexeKey,
      this.sexeName,
      this.deviseKey,
      this.deviseName,
      this.deviseAbreg,
      this.inscriptionPresta});

  UserResponse.fromJson(Map<String, dynamic> json) {
    nom = json['nom'];
    prenoms = json['prenoms'];
    username = json['username'];
    token = json['token'];
    adresse = json['adresse'];
    email = json['email'];
    paysId = json['paysId'];
    paysKey = json['pays_key'];
    paysName = json['pays_name'];
    photo = json['photo'];
    typeUserId = json['type_user_id'];
    typeUserKey = json['type_user_key'];
    typeUserName = json['type_user_name'];
    dateNaissance = json['date_naissance'];
    sexeKey = json['sexe_key'];
    sexeName = json['sexe_name'];
    deviseKey = json['devise_key'];
    deviseName = json['devise_name'];
    deviseAbreg = json['devise_abreg'];
    inscriptionPresta = json['inscription_presta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['username'] = username;
    data['token'] = token;
    data['adresse'] = adresse;
    data['email'] = email;
    data['paysId'] = paysId;
    data['pays_key'] = paysKey;
    data['pays_name'] = paysName;
    data['photo'] = photo;
    data['type_user_id'] = typeUserId;
    data['type_user_key'] = typeUserKey;
    data['type_user_name'] = typeUserName;
    data['date_naissance'] = dateNaissance;
    data['sexe_key'] = sexeKey;
    data['sexe_name'] = sexeName;
    data['devise_key'] = deviseKey;
    data['devise_name'] = deviseName;
    data['devise_abreg'] = deviseAbreg;
    data['inscription_presta'] = inscriptionPresta;
    return data;
  }
}
