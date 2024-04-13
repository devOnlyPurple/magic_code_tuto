class Pharmas {
  int? id;
  String? nom;
  int? prefectureId;
  String? prefectureNom;
  String? ville;
  String? contact1;
  String? contact2;
  String? email;
  String? adresse;
  int? typeHoraire;
  String? heureDebut;
  String? heureFin;
  String? latitude;
  String? longitude;
  String? mapLink;
  String? distance;
  String? keyPharmacie;
  int? etat;
  String? photo;

  Pharmas(
      {this.id,
      this.nom,
      this.prefectureId,
      this.prefectureNom,
      this.ville,
      this.contact1,
      this.contact2,
      this.email,
      this.adresse,
      this.typeHoraire,
      this.heureDebut,
      this.heureFin,
      this.latitude,
      this.longitude,
      this.mapLink,
      this.distance,
      this.keyPharmacie,
      this.etat,
      this.photo});

  Pharmas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prefectureId = json['prefecture_id'];
    prefectureNom = json['prefecture_nom'];
    ville = json['ville'];
    contact1 = json['contact_1'];
    contact2 = json['contact_2'];
    email = json['email'];
    adresse = json['adresse'];
    typeHoraire = json['type_horaire'];
    heureDebut = json['heure_debut'];
    heureFin = json['heure_fin'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mapLink = json['map_link'];
    distance = json['distance'];
    keyPharmacie = json['key_pharmacie'];
    etat = json['etat'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prefecture_id'] = prefectureId;
    data['prefecture_nom'] = prefectureNom;
    data['ville'] = ville;
    data['contact_1'] = contact1;
    data['contact_2'] = contact2;
    data['email'] = email;
    data['adresse'] = adresse;
    data['type_horaire'] = typeHoraire;
    data['heure_debut'] = heureDebut;
    data['heure_fin'] = heureFin;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['map_link'] = mapLink;
    data['distance'] = distance;
    data['key_pharmacie'] = keyPharmacie;
    data['etat'] = etat;
    data['photo'] = photo;
    return data;
  }
}
