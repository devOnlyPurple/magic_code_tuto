import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';

import 'package:kondjigbale/models/categorie_blog.dart';
import 'package:kondjigbale/models/categorie_conseil.dart';
import 'package:kondjigbale/models/groupe_sanguin.dart';
import 'package:kondjigbale/models/langue.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/models/specialite.dart';
import 'package:kondjigbale/models/type_consultation.dart';
import 'package:kondjigbale/models/type_rdv.dart';

import '../models/pays.dart';

class ListesProvider with ChangeNotifier {
  final int _count = 0;
  List<Sexe>? _sexe = [];
  List<Pays>? _pays = [];
  List<CategorieConseil>? _categoriesConseil = [];
  List<CategorieBlog>? _categoriesBlog = [];
  List<TypeConsultation>? _typeConsultations = [];
  List<Specialite> _specialites = [];
  List<Langue> _langues = [];
  List<GroupeSanguin>? _groupeSanguins = [];
  List<TypeRdv> _typeRdvArray = [];
  String? _defaultCountry = "";
  List<Country>? _listcountry = [];
  List<Sexe> get sexe => _sexe!;
  List<Pays> get pays => _pays!;
  List<Country> get listcountry => _listcountry!;
  List<CategorieConseil> get categoriesConseil => _categoriesConseil!;
  List<CategorieBlog> get categoriesBlog => _categoriesBlog!;
  List<TypeConsultation> get typeConsultations => _typeConsultations!;
  List<Specialite> get specialites => _specialites;
  List<Langue> get langues => _langues;
  List<GroupeSanguin> get groupeSanguins => _groupeSanguins!;
  List<TypeRdv> get typeRdvArray => _typeRdvArray;
  String? get defaultCountry => _defaultCountry!;

  set pays(List<Pays> listPays) {
    _pays = listPays;
    notifyListeners();
  }

  set sexe(List<Sexe> listSexe) {
    _sexe = listSexe;
    print("******");
    // print(_sexe);
    print('*********');
    notifyListeners();
  }

  set catConseil(List<CategorieConseil> listcategorieconseil) {
    _categoriesConseil = listcategorieconseil;

    notifyListeners();
  }

  set countryDefault(String dCountry) {
    _defaultCountry = dCountry;
  }

  void setsexe(List<Sexe> listSexe) {
    _sexe = listSexe;

    notifyListeners();
  }

  set country(List<Country> newlistcountry) {
    _listcountry = newlistcountry;
    notifyListeners();
  }

  set sanguinGroup(List<GroupeSanguin> newGroupeSanguins) {
    _groupeSanguins = newGroupeSanguins;
    notifyListeners();
  }

  set listcatblog(List<CategorieBlog>? newcategoriesBlog) {
    _categoriesBlog = newcategoriesBlog;

    print("**1***");
    print(_categoriesBlog![0].nom);
    print('*********');
    notifyListeners();
  }

  void setlistcatblog(List<CategorieBlog>? newcategoriesBlog) {
    _categoriesBlog = newcategoriesBlog;

    print(2);
    print(_categoriesBlog);
    notifyListeners();
  }

  set consultationtype(List<TypeConsultation> newtypeconsulting) {
    _typeConsultations = newtypeconsulting;
    notifyListeners();
  }

  set langueList(List<Langue> newlangueList) {
    _langues = newlangueList;
    notifyListeners();
  }

  set specialiteList(List<Specialite> newSpecialite) {
    _specialites = newSpecialite;
    notifyListeners();
  }

  set rendevous(List<TypeRdv> newRdv) {
    _typeRdvArray = newRdv;
    notifyListeners();
  }
}
