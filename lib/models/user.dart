class User {
  int? id;
  String? username;
  String? nom;
  String? prenoms;
  String? dateNaissance;
  String? numIdentifUnique;
  String? email;
  String? groupeSanguinKey;
  String? groupeSanguinName;
  Object? sexe;
  String? localisation;
  String? adresse;
  String? paysKey;
  String? paysNom;
  String? villeKey;
  String? villeNom;
  String? token;
  String? photo;
  String? userProfil;
  int? idUserProfil;
  int? solde;
  List<dynamic>? enfants;

  User(
      {this.id,
      this.username,
      this.nom,
      this.prenoms,
      this.dateNaissance,
      this.numIdentifUnique,
      this.email,
      this.groupeSanguinKey,
      this.groupeSanguinName,
      this.sexe,
      this.localisation,
      this.adresse,
      this.paysKey,
      this.paysNom,
      this.villeKey,
      this.villeNom,
      this.token,
      this.photo,
      this.userProfil,
      this.idUserProfil,
      this.solde,
      this.enfants});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    nom = json['nom'];
    prenoms = json['prenoms'];
    dateNaissance = json['date_naissance'];
    numIdentifUnique = json['num_identif_unique'];
    email = json['email'];
    groupeSanguinKey = json['groupe_sanguin_key'];
    groupeSanguinName = json['groupe_sanguin_name'];
    sexe = json['sexe'];
    localisation = json['localisation'];
    adresse = json['adresse'];
    paysKey = json['pays_key'];
    paysNom = json['pays_nom'];
    villeKey = json['ville_key'];
    villeNom = json['ville_nom'];
    token = json['token'];
    photo = json['photo'];
    userProfil = json['user_profil'];
    idUserProfil = json['id_user_profil'];
    solde = json['solde'];
    if (json['enfants'] != null) {
      enfants = [];
      json['enfants'].forEach((v) {
        if (v is Map<String, dynamic>) {
          enfants!.add(v);
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['date_naissance'] = dateNaissance;
    data['num_identif_unique'] = numIdentifUnique;
    data['email'] = email;
    data['groupe_sanguin_key'] = groupeSanguinKey;
    data['groupe_sanguin_name'] = groupeSanguinName;
    data['sexe'] = sexe;
    data['localisation'] = localisation;
    data['adresse'] = adresse;
    data['pays_key'] = paysKey;
    data['pays_nom'] = paysNom;
    data['ville_key'] = villeKey;
    data['ville_nom'] = villeNom;
    data['token'] = token;
    data['photo'] = photo;
    data['user_profil'] = userProfil;
    data['id_user_profil'] = idUserProfil;
    data['solde'] = solde;
    if (enfants != null) {
      data['enfants'] = enfants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
