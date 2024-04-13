// ignore_for_file: prefer_const_constructors

import 'package:dropdown_plus_plus/dropdown_plus_plus.dart';
import 'package:flutter/material.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/langue.dart';
import 'package:kondjigbale/models/specialite.dart';
import 'package:kondjigbale/models/type_consultation.dart';
import 'package:kondjigbale/models/ville.dart';

class FilterModal extends StatefulWidget {
  FilterModal({
    super.key,
    required this.villeList,
    required this.typeConsultations,
    required this.specialites,
    required this.langues,
    required this.speKey,
    required this.villeKey,
    required this.consKey,
    required this.langKey,
    required this.docName,
    required this.onLoadList,
  });
  List<Ville>? villeList;
  List<TypeConsultation>? typeConsultations;
  List<Specialite>? specialites;
  List<Langue>? langues;
  String? speKey;
  String? villeKey;
  String? consKey;
  String? langKey;
  String? docName;
  dynamic Function(String speKey, String consulKey, String symKey,
      String villeKey, String langKey, String docName)? onLoadList;
  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  String _selectVille = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.consKey);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: Text(
        'Filtrer médecins',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: 300,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Br10(),
              specialiteDoc(size),
              Br10(),
              villeList(size),
              Br10(),
              consultListe(size),
              Br10(),
              langueList(size),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(0);
          },
          child: Text(
            'Annuler',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            widget.onLoadList!(widget.speKey!, widget.consKey!, '',
                _selectVille, widget.langKey!, widget.docName!);
            Navigator.of(context).pop(1);
          },
          child: Text(
            'Appliquer',
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16, color: Kprimary),
          ),
        ),
      ],
    );
  }

  Widget villeList(Size size) {
    List<Map<String, dynamic>> villesAsMap = widget.villeList!.map((ville) {
      return {
        'key': ville.key,
        'nom': ville.nom,
      };
    }).toList();
    return Container(
      width: size.width,
      child: Column(
        children: [
          DropdownFormField<Map<String, dynamic>>(
            dropdownHeight: 200,
            onEmptyActionPressed: (String str) async {},
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Kprimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: kformFieldBackgroundColor,
                ),
              ),
              fillColor: kformFieldBackgroundColor,
              filled: true,
              hintText: 'Lieu',
              hintStyle: TextStyle(
                  fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            onSaved: (dynamic str) {},
            onChanged: (dynamic selectedValue) {
              if (selectedValue != null) {
                print(selectedValue['nom']);
              }
            },
            displayItemFn: (dynamic item) => Text(
              (item ?? {})['nom'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            findFn: (dynamic str) async => villesAsMap,
            selectedFn: (dynamic item1, dynamic item2) {
              if (item1 != null && item2 != null) {
                return item1['nom'] == item2['nom'];
              }
              return false;
            },
            autoFocus: false,
            filterFn: (dynamic item, str) =>
                item['nom'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
            dropdownItemFn: (dynamic item, int position, bool focused,
                    bool selected, Function() onTap) =>
                ListTile(
              title: Text(item['nom']),
              tileColor:
                  focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget consultListe(Size size) {
    List<Map<String, dynamic>> consultMap =
        widget.typeConsultations!.map((typeConsult) {
      return {
        'key': typeConsult.keyTypeConsultation,
        'nom': typeConsult.nom,
      };
    }).toList();
    return Container(
      width: size.width,
      child: Column(
        children: [
          DropdownFormField<Map<String, dynamic>>(
            onEmptyActionPressed: (String str) async {},
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Kprimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: kformFieldBackgroundColor,
                ),
              ),
              fillColor: kformFieldBackgroundColor,
              filled: true,
              hintText: 'Consultation',
              hintStyle: TextStyle(
                  fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            onSaved: (dynamic str) {},
            onChanged: (dynamic selectedValue) {
              if (selectedValue != null) {
                setState(() {
                  widget.consKey = selectedValue['key'];
                });
                print(widget.consKey);
              }
            },
            validator: null,
            displayItemFn: (dynamic item) => Text(
              (item ?? {})['nom'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            findFn: (dynamic str) async => consultMap,
            selectedFn: (dynamic item1, dynamic item2) {
              if (item1 != null && item2 != null) {
                return item1['nom'] == item2['nom'];
              }
              return false;
            },
            autoFocus: false,
            filterFn: (dynamic item, str) =>
                item['nom'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
            dropdownItemFn: (dynamic item, int position, bool focused,
                    bool selected, Function() onTap) =>
                ListTile(
              title: Text(item['nom']),
              tileColor:
                  focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }

  // langue

  Widget langueList(Size size) {
    List<Map<String, dynamic>> consultLangue = widget.langues!.map((langues) {
      return {
        'key': langues.keyLangue,
        'nom': langues.nom,
      };
    }).toList();
    return Container(
      width: size.width,
      child: Column(
        children: [
          DropdownFormField<Map<String, dynamic>>(
            dropdownHeight: 200,
            onEmptyActionPressed: (String str) async {},
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Kprimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: kformFieldBackgroundColor,
                ),
              ),
              fillColor: kformFieldBackgroundColor,
              filled: true,
              hintText: 'Langue',
              hintStyle: TextStyle(
                  fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            onSaved: (dynamic str) {},
            onChanged: (dynamic selectedValue) {
              if (selectedValue != null) {
                print(selectedValue['nom']);
              }
            },
            validator: null,
            displayItemFn: (dynamic item) => Text(
              (item ?? {})['nom'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            findFn: (dynamic str) async => consultLangue,
            selectedFn: (dynamic item1, dynamic item2) {
              if (item1 != null && item2 != null) {
                return item1['nom'] == item2['nom'];
              }
              return false;
            },
            autoFocus: false,
            filterFn: (dynamic item, str) =>
                item['nom'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
            dropdownItemFn: (dynamic item, int position, bool focused,
                    bool selected, Function() onTap) =>
                ListTile(
              title: Text(item['nom']),
              tileColor:
                  focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }

  //

  Widget specialiteDoc(Size size) {
    List<Map<String, dynamic>> specialMap = widget.specialites!.map((special) {
      return {
        'key': special.keySpecialite,
        'nom': special.nom,
      };
    }).toList();
    return Container(
      width: size.width,
      child: Column(
        children: [
          DropdownFormField<Map<String, dynamic>>(
            dropdownHeight: 200,
            onEmptyActionPressed: (String str) async {},
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Kprimary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: kformFieldBackgroundColor,
                ),
              ),
              fillColor: kformFieldBackgroundColor,
              filled: true,
              hintText: 'Specialités',
              hintStyle: TextStyle(
                  fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            onSaved: (dynamic str) {},
            onChanged: (dynamic selectedValue) {
              if (selectedValue != null) {
                print(selectedValue['nom']);
              }
            },
            validator: null,
            displayItemFn: (dynamic item) => Text(
              (item ?? {})['nom'] ?? '',
              style: TextStyle(fontSize: 16),
            ),
            findFn: (dynamic str) async => specialMap,
            selectedFn: (dynamic item1, dynamic item2) {
              if (item1 != null && item2 != null) {
                return item1['nom'] == item2['nom'];
              }
              return false;
            },
            autoFocus: false,
            filterFn: (dynamic item, str) =>
                item['nom'].toLowerCase().indexOf(str.toLowerCase()) >= 0,
            dropdownItemFn: (dynamic item, int position, bool focused,
                    bool selected, Function() onTap) =>
                ListTile(
              title: Text(item['nom']),
              tileColor:
                  focused ? Color.fromARGB(20, 0, 0, 0) : Colors.transparent,
              onTap: onTap,
            ),
          ),
        ],
      ),
    );
  }
}
