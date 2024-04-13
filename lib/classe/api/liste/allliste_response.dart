import 'package:kondjigbale/classe/api/liste/country_class.dart';
import 'package:kondjigbale/classe/api/liste/service_class.dart';

import 'package:kondjigbale/classe/api/liste/sexe_class.dart';

class ListAllResponse {
  String? status;
  String? message;
  Information? information;

  ListAllResponse({this.status, this.message, this.information});

  ListAllResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    information = json['information'] != null
        ? Information.fromJson(json['information'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (information != null) {
      data['information'] = information!.toJson();
    }
    return data;
  }
}

class Information {
  List<Sexe>? sexe;
  List<Pays>? pays;
  List<Services>? services;
  String? defaultCountry;
  String? demandeCondition;

  Information(
      {this.sexe,
      this.pays,
      this.services,
      this.defaultCountry,
      this.demandeCondition});

  Information.fromJson(Map<String, dynamic> json) {
    if (json['sexe'] != null) {
      sexe = <Sexe>[];
      json['sexe'].forEach((v) {
        sexe!.add(Sexe.fromJson(v));
      });
    }
    if (json['pays'] != null) {
      pays = <Pays>[];
      json['pays'].forEach((v) {
        pays!.add(Pays.fromJson(v));
      });
    }
    if (json['services'] != null) {
      services = <Services>[];
      json['services'].forEach((v) {
        services!.add(Services.fromJson(v));
      });
    }
    defaultCountry = json['default_country'];
    demandeCondition = json['demande_condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sexe != null) {
      data['sexe'] = sexe!.map((v) => v.toJson()).toList();
    }
    if (pays != null) {
      data['pays'] = pays!.map((v) => v.toJson()).toList();
    }
    if (services != null) {
      data['services'] = services!.map((v) => v.toJson()).toList();
    }
    data['default_country'] = defaultCountry;
    data['demande_condition'] = demandeCondition;
    return data;
  }
}
