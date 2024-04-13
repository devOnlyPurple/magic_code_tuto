class Pays {
  int? id;
  String? keyPays;
  int? code;
  String? nomAbrev;
  String? nomPays;
  String? indicatif;
  int? statut;
  String? devise;
  String? drapeau;

  Pays(
      {this.id,
        this.keyPays,
        this.code,
        this.nomAbrev,
        this.nomPays,
        this.indicatif,
        this.statut,
        this.devise,
        this.drapeau});

  Pays.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyPays = json['key_pays'];
    code = json['code'];
    nomAbrev = json['nom_abrev'];
    nomPays = json['nom_pays'];
    indicatif = json['indicatif'];
    statut = json['statut'];
    devise = json['devise'];
    drapeau = json['drapeau'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key_pays'] = keyPays;
    data['code'] = code;
    data['nom_abrev'] = nomAbrev;
    data['nom_pays'] = nomPays;
    data['indicatif'] = indicatif;
    data['statut'] = statut;
    data['devise'] = devise;
    data['drapeau'] = drapeau;
    return data;
  }
}
