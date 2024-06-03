import 'package:kondjigbale/models/prestataire.dart';

class Rdv {
  String? keyRendezVous;
  String? patientToken;
  String? prestataireToken;
  String? keyTypeConsultation;
  String? keyNameConsultation;
  String? tarif;
  String? montantPaye;
  String? localisationDomicile;
  String? dateRdv;
  String? heureDebut;
  String? heureFin;
  String? motifRdv;
  String? motifRejet;
  int? etat;
  int? typeRdv;
  String? callLink;
  String? dateCreate;
  Prestataire? prestataire;

  Rdv(
      {this.keyRendezVous,
      this.patientToken,
      this.prestataireToken,
      this.keyTypeConsultation,
      this.keyNameConsultation,
      this.tarif,
      this.montantPaye,
      this.localisationDomicile,
      this.dateRdv,
      this.heureDebut,
      this.heureFin,
      this.motifRdv,
      this.motifRejet,
      this.etat,
      this.typeRdv,
      this.callLink,
      this.dateCreate,
      this.prestataire});

  Rdv.fromJson(Map<String, dynamic> json) {
    keyRendezVous = json['key_rendez_vous'];
    patientToken = json['patient_token'];
    prestataireToken = json['prestataire_token'];
    keyTypeConsultation = json['key_type_consultation'];
    keyNameConsultation = json['key_name_consultation'];
    tarif = json['tarif'];
    montantPaye = json['montant_paye'];
    localisationDomicile = json['localisation_domicile'];
    dateRdv = json['date_rdv'];
    heureDebut = json['heure_debut'];
    heureFin = json['heure_fin'];
    motifRdv = json['motif_rdv'];
    motifRejet = json['motif_rejet'];
    etat = json['etat'];
    typeRdv = json['type_rdv'];
    callLink = json['call_link'];
    dateCreate = json['date_create'];
    prestataire = json['prestataire'] != null
        ? Prestataire.fromJson(json['prestataire'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key_rendez_vous'] = keyRendezVous;
    data['patient_token'] = patientToken;
    data['prestataire_token'] = prestataireToken;
    data['key_type_consultation'] = keyTypeConsultation;
    data['key_name_consultation'] = keyNameConsultation;
    data['tarif'] = tarif;
    data['montant_paye'] = montantPaye;
    data['localisation_domicile'] = localisationDomicile;
    data['date_rdv'] = dateRdv;
    data['heure_debut'] = heureDebut;
    data['heure_fin'] = heureFin;
    data['motif_rdv'] = motifRdv;
    data['motif_rejet'] = motifRejet;
    data['etat'] = etat;
    data['type_rdv'] = typeRdv;
    data['call_link'] = callLink;
    data['date_create'] = dateCreate;
    if (prestataire != null) {
      data['prestataire'] = prestataire!.toJson();
    }
    return data;
  }
}