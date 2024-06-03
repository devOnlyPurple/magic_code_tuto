import 'package:flutter/material.dart';
import 'package:kondjigbale/models/pharmas.dart';
import 'package:kondjigbale/models/user.dart';
import 'pharma_methode.dart'; // Assurez-vous que le fichier pharma_methode.dart est correctement importé depuis le bon emplacement

class PharmaciesList extends StatefulWidget {
  final Size size;
  final List<Pharmas> pharmacies;
  final bool isSearching;
  final List<Pharmas> filteredList;
  final User userResponse;

  const PharmaciesList({
    required this.size,
    required this.pharmacies,
    required this.isSearching,
    required this.filteredList,
    required this.userResponse,
  });

  @override
  _PharmaciesListState createState() => _PharmaciesListState();
}

class _PharmaciesListState extends State<PharmaciesList> {
  @override
  Widget build(BuildContext context) {
    return listpharmaMethode(
      widget.size,
      widget.pharmacies,
      widget.isSearching,
      widget.filteredList,
      widget.userResponse,
    );
  }
}
