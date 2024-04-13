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
        ? new Prestataire.fromJson(json['prestataire'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key_rendez_vous'] = this.keyRendezVous;
    data['patient_token'] = this.patientToken;
    data['prestataire_token'] = this.prestataireToken;
    data['key_type_consultation'] = this.keyTypeConsultation;
    data['key_name_consultation'] = this.keyNameConsultation;
    data['tarif'] = this.tarif;
    data['montant_paye'] = this.montantPaye;
    data['localisation_domicile'] = this.localisationDomicile;
    data['date_rdv'] = this.dateRdv;
    data['heure_debut'] = this.heureDebut;
    data['heure_fin'] = this.heureFin;
    data['motif_rdv'] = this.motifRdv;
    data['motif_rejet'] = this.motifRejet;
    data['etat'] = this.etat;
    data['type_rdv'] = this.typeRdv;
    data['call_link'] = this.callLink;
    data['date_create'] = this.dateCreate;
    if (this.prestataire != null) {
      data['prestataire'] = this.prestataire!.toJson();
    }
    return data;
  }
}