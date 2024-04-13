class Garde {
  int? id;
  String? dateDebut;
  String? dateFin;
  String? pharmacieIds;

  Garde({this.id, this.dateDebut, this.dateFin, this.pharmacieIds});

  Garde.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateDebut = json['date_debut'];
    dateFin = json['date_fin'];
    pharmacieIds = json['pharmacie_ids'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date_debut'] = dateDebut;
    data['date_fin'] = dateFin;
    data['pharmacie_ids'] = pharmacieIds;
    return data;
  }
}
