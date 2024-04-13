import 'package:kondjigbale/models/presta_association.dart';
import 'package:kondjigbale/models/presta_experience.dart';
import 'package:kondjigbale/models/presta_formations.dart';
import 'package:kondjigbale/models/presta_travaux.dart';
import 'package:kondjigbale/models/rdv_response.dart';
import 'package:kondjigbale/models/rdv_typeConsulting.dart';

class Prestataire {
  String? id;
  String? token;
  String? username;
  String? nom;
  String? prenoms;
  String? numIdentifUnique;
  String? sexeKey;
  String? sexeName;
  String? photo;
  String? email;
  String? localisation;
  String? adresse;
  String? villeKey;
  String? villeNom;
  int? numeroOrdre;
  String? keySpecialite;
  String? denominationSpecialite;
  String? keyLangue;
  String? denominationLangue;
  List<TypeConsultations>? typeConsultations;
  String? expertises;
  List<Associations>? associations;
  List<Formations>? formations;
  List<Experiences>? experiences;
  List<Travaux>? travaux;

  Prestataire(
      {this.id,
      this.token,
      this.username,
      this.nom,
      this.prenoms,
      this.numIdentifUnique,
      this.sexeKey,
      this.sexeName,
      this.photo,
      this.email,
      this.localisation,
      this.adresse,
      this.villeKey,
      this.villeNom,
      this.numeroOrdre,
      this.keySpecialite,
      this.denominationSpecialite,
      this.keyLangue,
      this.denominationLangue,
      this.typeConsultations,
      this.expertises,
      this.associations,
      this.formations,
      this.experiences,
      this.travaux});

  Prestataire.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    token = json['token'];
    username = json['username'];
    nom = json['nom'];
    prenoms = json['prenoms'];
    numIdentifUnique = json['num_identif_unique'];
    sexeKey = json['sexe_key'].toString();
    sexeName = json['sexe_name'];
    photo = json['photo'];
    email = json['email'];
    localisation = json['localisation'];
    adresse = json['adresse'];
    villeKey = json['ville_key'];
    villeNom = json['ville_nom'];
    numeroOrdre = json['numero_ordre'];
    keySpecialite = json['key_specialite'];
    denominationSpecialite = json['denomination_specialite'];
    keyLangue = json['key_langue'];
    denominationLangue = json['denomination_langue'];
    if (json['type_consultations'] != null) {
      typeConsultations = <TypeConsultations>[];
      json['type_consultations'].forEach((v) {
        typeConsultations!.add(new TypeConsultations.fromJson(v));
      });
    }
    expertises = json['expertises'];
    if (json['associations'] != null) {
      associations = <Associations>[];
      json['associations'].forEach((v) {
        associations!.add(new Associations.fromJson(v));
      });
    }
    if (json['formations'] != null) {
      formations = <Formations>[];
      json['formations'].forEach((v) {
        formations!.add(new Formations.fromJson(v));
      });
    }
    if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((v) {
        experiences!.add(new Experiences.fromJson(v));
      });
    }
    if (json['travaux'] != null) {
      travaux = <Travaux>[];
      json['travaux'].forEach((v) {
        travaux!.add(new Travaux.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['username'] = this.username;
    data['nom'] = this.nom;
    data['prenoms'] = this.prenoms;
    data['num_identif_unique'] = this.numIdentifUnique;
    data['sexe_key'] = this.sexeKey;
    data['sexe_name'] = this.sexeName;
    data['photo'] = this.photo;
    data['email'] = this.email;
    data['localisation'] = this.localisation;
    data['adresse'] = this.adresse;
    data['ville_key'] = this.villeKey;
    data['ville_nom'] = this.villeNom;
    data['numero_ordre'] = this.numeroOrdre;
    data['key_specialite'] = this.keySpecialite;
    data['denomination_specialite'] = this.denominationSpecialite;
    data['key_langue'] = this.keyLangue;
    data['denomination_langue'] = this.denominationLangue;
    if (this.typeConsultations != null) {
      data['type_consultations'] =
          this.typeConsultations!.map((v) => v.toJson()).toList();
    }
    data['expertises'] = this.expertises;
    if (this.associations != null) {
      data['associations'] = this.associations!.map((v) => v.toJson()).toList();
    }
    if (this.formations != null) {
      data['formations'] = this.formations!.map((v) => v.toJson()).toList();
    }
    if (this.experiences != null) {
      data['experiences'] = this.experiences!.map((v) => v.toJson()).toList();
    }
    if (this.travaux != null) {
      data['travaux'] = this.travaux!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
