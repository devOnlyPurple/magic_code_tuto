import 'package:kondjigbale/models/categorie_blog.dart';
import 'package:kondjigbale/models/categorie_conseil.dart';
import 'package:kondjigbale/models/groupe_sanguin.dart';
import 'package:kondjigbale/models/langue.dart';
import 'package:kondjigbale/models/pays.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/models/specialite.dart';
import 'package:kondjigbale/models/type_consultation.dart';
import 'package:kondjigbale/models/type_rdv.dart';

class ListesResponse {
  String? status;
  String? message;
  Information? information;

  ListesResponse({this.status, this.message, this.information});

  ListesResponse.fromJson(Map<String, dynamic> json) {
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
  List<CategorieConseil>? categoriesConseil;
  List<CategorieBlog>? categoriesBlog;
  List<TypeConsultation>? typeConsultations;
  List<Specialite>? specialites;
  List<Langue>? langues;
  List<GroupeSanguin>? groupeSanguins;
  List<TypeRdv>? typeRdvArray;
  String? defaultCountry;

  Information(
      {this.sexe,
      this.pays,
      this.categoriesConseil,
      this.categoriesBlog,
      this.typeConsultations,
      this.specialites,
      this.langues,
      this.groupeSanguins,
      this.typeRdvArray,
      this.defaultCountry});

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
    if (json['categories_conseil'] != null) {
      categoriesConseil = <CategorieConseil>[];
      json['categories_conseil'].forEach((v) {
        categoriesConseil!.add(CategorieConseil.fromJson(v));
      });
    }
    if (json['categories_blog'] != null) {
      categoriesBlog = <CategorieBlog>[];
      json['categories_blog'].forEach((v) {
        categoriesBlog!.add(CategorieBlog.fromJson(v));
      });
    }
    if (json['type_consultations'] != null) {
      typeConsultations = <TypeConsultation>[];
      json['type_consultations'].forEach((v) {
        typeConsultations!.add(TypeConsultation.fromJson(v));
      });
    }
    if (json['specialites'] != null) {
      specialites = <Specialite>[];
      json['specialites'].forEach((v) {
        specialites!.add(Specialite.fromJson(v));
      });
    }
    if (json['langues'] != null) {
      langues = <Langue>[];
      json['langues'].forEach((v) {
        langues!.add(Langue.fromJson(v));
      });
    }
    if (json['groupe_sanguins'] != null) {
      groupeSanguins = <GroupeSanguin>[];
      json['groupe_sanguins'].forEach((v) {
        groupeSanguins!.add(GroupeSanguin.fromJson(v));
      });
    }
    if (json['type_rdv_array'] != null) {
      typeRdvArray = <TypeRdv>[];
      json['type_rdv_array'].forEach((v) {
        typeRdvArray!.add(TypeRdv.fromJson(v));
      });
    }
    defaultCountry = json['default_country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sexe != null) {
      data['sexe'] = sexe!.map((v) => v.toJson()).toList();
    }
    if (pays != null) {
      data['pays'] = pays!.map((v) => v.toJson()).toList();
    }
    if (categoriesConseil != null) {
      data['categories_conseil'] =
          categoriesConseil!.map((v) => v.toJson()).toList();
    }
    if (categoriesBlog != null) {
      data['categories_blog'] =
          categoriesBlog!.map((v) => v.toJson()).toList();
    }
    if (typeConsultations != null) {
      data['type_consultations'] =
          typeConsultations!.map((v) => v.toJson()).toList();
    }
    if (specialites != null) {
      data['specialites'] = specialites!.map((v) => v.toJson()).toList();
    }
    if (langues != null) {
      data['langues'] = langues!.map((v) => v.toJson()).toList();
    }
    if (groupeSanguins != null) {
      data['groupe_sanguins'] =
          groupeSanguins!.map((v) => v.toJson()).toList();
    }
    if (typeRdvArray != null) {
      data['type_rdv_array'] =
          typeRdvArray!.map((v) => v.toJson()).toList();
    }
    data['default_country'] = defaultCountry;
    return data;
  }
}
