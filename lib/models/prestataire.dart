import 'package:kondjigbale/models/presta_association.dart';
import 'package:kondjigbale/models/presta_experience.dart';
import 'package:kondjigbale/models/presta_formations.dart';
import 'package:kondjigbale/models/presta_travaux.dart';
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
        typeConsultations!.add(TypeConsultations.fromJson(v));
      });
    }
    expertises = json['expertises'];
    if (json['associations'] != null) {
      associations = <Associations>[];
      json['associations'].forEach((v) {
        associations!.add(Associations.fromJson(v));
      });
    }
    if (json['formations'] != null) {
      formations = <Formations>[];
      json['formations'].forEach((v) {
        formations!.add(Formations.fromJson(v));
      });
    }
    if (json['experiences'] != null) {
      experiences = <Experiences>[];
      json['experiences'].forEach((v) {
        experiences!.add(Experiences.fromJson(v));
      });
    }
    if (json['travaux'] != null) {
      travaux = <Travaux>[];
      json['travaux'].forEach((v) {
        travaux!.add(Travaux.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['token'] = token;
    data['username'] = username;
    data['nom'] = nom;
    data['prenoms'] = prenoms;
    data['num_identif_unique'] = numIdentifUnique;
    data['sexe_key'] = sexeKey;
    data['sexe_name'] = sexeName;
    data['photo'] = photo;
    data['email'] = email;
    data['localisation'] = localisation;
    data['adresse'] = adresse;
    data['ville_key'] = villeKey;
    data['ville_nom'] = villeNom;
    data['numero_ordre'] = numeroOrdre;
    data['key_specialite'] = keySpecialite;
    data['denomination_specialite'] = denominationSpecialite;
    data['key_langue'] = keyLangue;
    data['denomination_langue'] = denominationLangue;
    if (typeConsultations != null) {
      data['type_consultations'] =
          typeConsultations!.map((v) => v.toJson()).toList();
    }
    data['expertises'] = expertises;
    if (associations != null) {
      data['associations'] = associations!.map((v) => v.toJson()).toList();
    }
    if (formations != null) {
      data['formations'] = formations!.map((v) => v.toJson()).toList();
    }
    if (experiences != null) {
      data['experiences'] = experiences!.map((v) => v.toJson()).toList();
    }
    if (travaux != null) {
      data['travaux'] = travaux!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
