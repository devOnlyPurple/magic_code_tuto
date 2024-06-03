// ignore_for_file: prefer_const_constructors

import 'package:dropdown_plus_plus/dropdown_plus_plus.dart';
import 'package:flutter/material.dart';

import '../../../helpers/constants/constant.dart';
import '../../../helpers/utils/sizeconfig.dart';
import '../../../models/langue.dart';
import '../../../models/specialite.dart';
import '../../../models/type_consultation.dart';
import '../../../models/ville.dart';

class FilterDialog extends StatefulWidget {
  FilterDialog({
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
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Br20(),
              Row(
                children: [
                  Text(
                    "Filtrer médecins",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop(0);
                      },
                      child: Icon(
                        Icons.close,
                        color: Kprimary,
                        size: 25,
                      )),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              Br20(),
              specialiteDoc(size),
              Br10(),
              villeList(size),
              Br10(),
              consultListe(size),
              Br10(),
              langueList(size),
              Br50(),
              Row(
                children: [
                  Expanded(
                    child: _cancelButtonMethod(),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: _confirmButtonMethod(),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // ville list
  Widget villeList(Size size) {
    List<Map<String, dynamic>> villesAsMap = widget.villeList!.map((ville) {
      return {
        'key': ville.key,
        'nom': ville.nom,
      };
    }).toList();
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          DropdownFormField<Map<String, dynamic>>(
            dropdownHeight: 520,
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
                setState(() {
                  widget.villeKey = selectedValue['key'];
                });
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

  // consult list
  Widget consultListe(Size size) {
    List<Map<String, dynamic>> consultMap =
        widget.typeConsultations!.map((typeConsult) {
      return {
        'key': typeConsult.keyTypeConsultation,
        'nom': typeConsult.nom,
      };
    }).toList();
    return SizedBox(
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
    return SizedBox(
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
                setState(() {
                  widget.langKey = selectedValue['key'];
                });
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

  //specialite

  Widget specialiteDoc(Size size) {
    List<Map<String, dynamic>> specialMap = widget.specialites!.map((special) {
      return {
        'key': special.keySpecialite,
        'nom': special.nom,
      };
    }).toList();
    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          DropdownFormField<Map<String, dynamic>>(
            dropdownHeight: 450,
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
                setState(() {
                  widget.speKey = selectedValue['key'];
                });
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

  SizedBox _cancelButtonMethod() {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: InkWell(
          onTap: () async {
            Navigator.of(context).pop(0);
          },
          child: Container(
            // width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: BoxDecoration(
                color: kRed, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Annuler",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ));
  }

  SizedBox _confirmButtonMethod() {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: InkWell(
          onTap: () async {
            widget.onLoadList!(widget.speKey!, widget.consKey!, '',
                widget.villeKey!, widget.langKey!, widget.docName!);
            Navigator.of(context).pop(1);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Appliquer",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ));
  }
}
