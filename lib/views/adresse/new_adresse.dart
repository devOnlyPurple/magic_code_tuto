// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/sizeconfig.dart';
import 'package:kondjigbale/models/uneAdresse_response.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:validatorless/validatorless.dart';

class AdresseNewPage extends StatefulWidget {
  AdresseNewPage({super.key, required this.uIdentifiant});
  String uIdentifiant;
  @override
  State<AdresseNewPage> createState() => _AdresseNewPageState();
}

class _AdresseNewPageState extends State<AdresseNewPage> {
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  double lat = 0.0;
  double long = 0.0;
  int adresseStatus = 0;
  String _locationMessage = '';

  Future<void> _getLocation() async {
    // Vérifier les autorisations de localisation
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Demander l'autorisation de localisation si elle n'est pas accordée
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      // L'utilisateur a refusé l'accès à la localisation en permanence
      setState(() {
        _locationMessage =
            'La permission de localisation est refusée. Veuillez l\'activer dans les paramètres de l\'application.';
      });
      return;
    }

    // Obtenir la position actuelle
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    Navigator.pop(context);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      print(lat);
      adresseStatus = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop(0);
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 13,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Br10(),
              const Center(
                child: Text(
                  // ignore: prefer_interpolation_to_compose_strings
                  "Nouvelle adresse",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
              ),
              Br30(),
              if (adresseStatus != 0) _latlong(),
              FormMethod(),
              Br20(),
              recup(),
              Br30(),
              if (adresseStatus != 0) ConfirmButtonMethod(),
            ],
          ),
        ),
      ),
    );
  }

  Form FormMethod() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            nameMethode(),
            Br10(),
            desciptionMethode(),
          ],
        ));
  }

  SizedBox nameMethode() {
    return SizedBox(
      child: TextFormField(
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          controller: _name,
          validator: Validatorless.required(VALIDATOR_REQUIRED),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: kformFieldBackgroundColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: kformFieldBackgroundColor,
              ),
            ),
            fillColor: kformFieldBackgroundColor,
            filled: true,
            border: OutlineInputBorder(
                // borderSide: new BorderSide(color:Colors.green)
                ),
            hintText: 'Nom',
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
            prefixText: ' ',
          )),
    );
  }

  SizedBox desciptionMethode() {
    return SizedBox(
      height: 100,
      child: TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: 3,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          controller: _description,
          validator: Validatorless.required(VALIDATOR_REQUIRED),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: kformFieldBackgroundColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: kformFieldBackgroundColor,
              ),
            ),
            fillColor: kformFieldBackgroundColor,
            filled: true,
            border: OutlineInputBorder(
                // borderSide: new BorderSide(color:Colors.green)
                ),
            hintText: 'Description',
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
            prefixText: ' ',
          )),
    );
  }

  InkWell recup() {
    return InkWell(
      onTap: () async {
        CustomLoading(context,
            status: "récupération de la position actuelle en cours...");
        _getLocation();
      },
      child: Text(
        "Récupérer ma position actuelle",
        style: TextStyle(
            color: Kprimary, fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _latlong() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(left: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Longitude: $long"),
            Br3(),
            Text("Latitude: $lat"),
            Br20(),
          ],
        ),
      ),
    );
  }

  SizedBox ConfirmButtonMethod() {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: InkWell(
          onTap: () async {
            // await _appSharedPreferences.setUserComplete(true);
            if (_formKey.currentState!.validate()) {
              // Boite de chargement
              CustomLoading(context,
                  status: "Enregistrement de l'adresse en cours...");
              _creatanewadress();
            } else {
              print("12");
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 14,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Enrégistrer ma localistation",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ));
  }

  _creatanewadress() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataAdresse = {
        'u_identifiant': widget.uIdentifiant,
        'nom': _name.value.text,
        'description': _description.value.text,
        'latitude_adresse': lat.toString(),
        'longitude_adresse': long.toString(),
      };

      UneAdresseResponse responseAdresse =
          await ApiRepository.addAdresse(dataAdresse);
      Navigator.pop(context);

      if (responseAdresse.status == API_SUCCES_STATUS) {
        Navigator.pop(context, 1);
      } else {
        var message = responseAdresse.message.toString();
        UiSnackbar.showSnackbar(context, message, false);
      }
    } else {
      print("no connexion");
      CustomErrorDialog(
        context,
        content: "Vérifiez votre connexion internet",
        buttonText: "Réessayez",
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }
  }
}
