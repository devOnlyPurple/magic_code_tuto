// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/models/adresse_response.dart';
import 'package:kondjigbale/models/uneAdresse_response.dart';
import 'package:kondjigbale/models/une_adresse.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/views/adresse/edit_adresse.dart';
import 'package:kondjigbale/views/adresse/new_adresse.dart';
import 'package:kondjigbale/widget/empty_page.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:url_launcher/url_launcher.dart';

class AdresseHome extends StatefulWidget {
  AdresseHome({super.key, required this.userResponse});
  User userResponse;
  @override
  State<AdresseHome> createState() => _AdresseHomeState();
}

class _AdresseHomeState extends State<AdresseHome> {
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  int loadingStatus = 0;
  List<Adresse> lesAdresses = [];
  String aresseSelect = 'Adresse';
  Future<void> getAdresse() async {
    final Map<String, String> dataAdresse = {
      'u_identifiant': widget.userResponse.token!,
    };
    AdresseResponse listeAdresse = await ApiRepository.listAdresse(dataAdresse);
    if (listeAdresse.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          lesAdresses = listeAdresse.information!;
          loadingStatus = 1;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          loadingStatus = 1;
        });
      }
      print(
        listeAdresse.message,
      );
    }
  }

  _launchMap(Uri url) async {
    await launchUrl(url);
  }

  Future<void> launchAllfunction() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      getAdresse();
    } else {
      print("no connexion");
      CustomErrorDialog(
        context,
        content: "Vérifiez votre connexion internet",
        buttonText: "Réessayez",
        onPressed: () {
          launchAllfunction();
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    launchAllfunction();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Br10(),
            Center(
              child: Text(
                // ignore: prefer_interpolation_to_compose_strings
                "Mes adresses",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
              ),
            ),
            Br30(),
            if (loadingStatus == 0)
              Center(
                // Affichez un indicateur de chargement tant que _isLoading est vrai
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Br50(),
                    CircularProgressIndicator(
                      backgroundColor: Kprimary,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                    Br10(),
                    Text("Chargement des adresses en cours")
                  ],
                ),
              )
            else if (lesAdresses.isNotEmpty)
              adresseBox(size)
            else
              EmptyPage(title: 'Aucune adresse enrégistré')
          ]),
        ),
      ),
      floatingActionButton: FloatingButtonMethod(),
    );
  }

  Container FloatingButtonMethod() {
    return Container(
      decoration:
          BoxDecoration(color: Kgreen, borderRadius: BorderRadius.circular(15)),
      child: TextButton.icon(
          onPressed: () async {
            final responseAdresse = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AdresseNewPage(
                          uIdentifiant: widget.userResponse.token!,
                        )));
            setState(() {
              if (responseAdresse == 1) {
                getAdresse();
                print(1);
              }
            });
          },
          icon: const Icon(
            Icons.add,
            color: kWhite,
          ),
          label: const Text(
            "Nouvelle adresse ",
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: kWhite),
          )),
    );
  }

  Widget adresseBox(Size size) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: lesAdresses.length,
        itemBuilder: (context, i) {
          Adresse uneAdresse = lesAdresses[i];
          return InkWell(
            onTap: () async {
              final responseAdresseEdit = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AdresseEditPage(
                            uIdentifiant: widget.userResponse.token!,
                            uneAdresse: uneAdresse,
                          )));
              setState(() {
                if (responseAdresseEdit == 1) {
                  getAdresse();
                  print(1);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 90,
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.location_on,
                      color: Kprimary,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          uneAdresse.nomAdresse!,
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Br3(),
                        Text(
                          uneAdresse.description!,
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: kBlack),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              CustomChoixDialog(context,
                                  title: "Supprimer",
                                  content:
                                      "Voulez vous supprimer cette adresse?",
                                  acceptText: "Oui",
                                  cancelText: "Non", cancelPress: () {
                                Navigator.of(context).pop();
                              }, acceptPress: () {
                                Navigator.of(context).pop();
                                CustomLoading(context,
                                    status:
                                        "suppresion de l'adresse en cours...");
                                _deteleteAdresse(uneAdresse.keyAdresse!);
                              });
                            },
                            icon: Icon(
                              Icons.remove_circle,
                              color: kRed,
                            )),
                        InkWell(
                          onTap: () {
                            _launchMap(Uri.parse(uneAdresse.adresseLink!));
                          },
                          child: Container(
                            height: 25,
                            width: size.width / 3,
                            decoration: BoxDecoration(
                                color: Kprimary.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(7.5)),
                            child: Center(
                              child: Text(
                                "Voir sur une carte",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Kprimary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  _deteleteAdresse(String keyAdresse) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataAdresse = {
        'u_identifiant': widget.userResponse.token!,
        'a_identifiant': keyAdresse,
        'operation': '3'
      };

      UneAdresseResponse responseAdresse =
          await ApiRepository.deleteAdresse(dataAdresse);
      Navigator.pop(context);

      if (responseAdresse.status == API_SUCCES_STATUS) {
        getAdresse();
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
