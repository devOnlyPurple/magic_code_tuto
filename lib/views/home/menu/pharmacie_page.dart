// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';

import 'package:kondjigbale/models/garde.dart';
import 'package:kondjigbale/models/pharmacie_response.dart';
import 'package:kondjigbale/models/pharmas.dart';
import 'package:kondjigbale/models/user.dart';

import 'package:kondjigbale/providers/user_provider.dart';
import 'package:kondjigbale/views/home/pharmacies/detail_pharmacie.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';

import 'package:provider/provider.dart';

class PharmaPage extends StatefulWidget {
  const PharmaPage({super.key});

  @override
  State<PharmaPage> createState() => _PharmaPageState();
}

class _PharmaPageState extends State<PharmaPage> {
  final List<String> tabTitles = ['Toutes', 'De garde', 'A proximité'];
  List<Pharmas> listePharma = [];
  List<Pharmas> listePharmaGarde = [];
  List<Pharmas> listprochePharma = [];
  late User userResponse = User(prenoms: "");
  late Garde pharmaGARDE = Garde(pharmacieIds: '');
  final ClassUtils classUtils = ClassUtils();
  final storage = FlutterSecureStorage();
  final ClassUtils _classUtils = ClassUtils();
  int loadingStatus = 0;
  String uIdentifiant = '';
  String jsonString = '';
  late List<int> pharmacyIds;
  Future<void> getPharaList(String uIdentifiant) async {
    final Map<String, String> dataMenu = {
      'u_identifiant': uIdentifiant,
    };
    PharmaciesResponse listeMenu = await ApiRepository.listPharma(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          listePharma = listeMenu.information!.pharmas!;
          loadingStatus = 1;
          listprochePharma = List.from(listePharma);

          pharmaGARDE = listeMenu.information!.garde!;
          jsonString = pharmaGARDE.pharmacieIds!;
          pharmacyIds = jsonDecode(jsonString)
              .map<int>((idString) => int.parse(idString))
              .toList();
          listePharmaGarde = listePharma
              .where((pharmacy) => pharmacyIds.contains(pharmacy.id))
              .toList();
          listePharmaGarde.sort((a, b) {
            double distanceA = double.parse(a.distance!);
            double distanceB = double.parse(b.distance!);

            return distanceA.compareTo(distanceB);
          });
          listprochePharma.sort((a, b) {
            double distanceA = double.parse(a.distance!);
            double distanceB = double.parse(b.distance!);

            return distanceA.compareTo(distanceB);
          });
        });
      }
    } else {
      if (mounted) {
        setState(() {
          loadingStatus = 1;
        });
      }
      print(
        listeMenu.message,
      );
    }
  }

  final ConnectivityChecker _connectivity = ConnectivityChecker();
  Future<void> launchAllfunction(String uIdentifiant) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      getPharaList(uIdentifiant);
    } else {
      print("no connexion");
      CustomErrorDialog(
        context,
        content: "Vérifiez votre connexion internet",
        buttonText: "Réessayez",
        onPressed: () {
          launchAllfunction(uIdentifiant);
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadInformation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: const [
              Tab(
                text: "Toutes",
              ),
              Tab(
                text: 'De garde',
              ),
              Tab(
                text: 'A proximité',
              ),
            ],
          ),
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
          ),
          title: const Text(
            "Pharmacies",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            InkWell(
              onTap: () {},
              child: Icon(Icons.calendar_month),
            ),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {},
              child: Icon(Icons.refresh_rounded),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        body: TabBarView(
          children:
              _buildTabBarViews(size), // Ajoutez les pages d'onglet réelles ici
        ),
      ),
    );
  }

  Future _loadInformation() async {
    final user = Provider.of<UsersProvider>(context, listen: false);
    _classUtils.getUserInformation().then((value) {
      setState(() {
        userResponse = value;
        uIdentifiant = value.token!;
      });
      user.userInfo = value;
      launchAllfunction(uIdentifiant);
      // extractPharmacyIds(jsonString);
    });
  }

  List<Widget> _buildTabs() {
    return tabTitles.map((title) => Tab(text: title)).toList();
  }

  List<Widget> _buildTabBarViews(Size size) {
    return [
      SingleChildScrollView(
        child: Column(
          children: [
            Br20(),
            Container(
                padding: EdgeInsets.all(15.0),
                child: loadingStatus == 0
                    ? Center(
                        // Affichez un indicateur de chargement tant que loadingStatus est égal à 0
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 50),
                            CircularProgressIndicator(
                              backgroundColor: Kprimary,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text("Chargement des pharmacies en cours"),
                          ],
                        ),
                      )
                    : listpharmaMethode(size, listePharma)),
          ],
        ),
      ),
      SingleChildScrollView(
        child: Column(
          children: [
            Br20(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 40,
                width: size.width,
                decoration: BoxDecoration(color: Ksecondary),
                child: Center(
                    child: Text(
                  "Période du ${pharmaGARDE.dateDebut} au ${pharmaGARDE.dateFin} ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: kWhite, fontSize: 15),
                )),
              ),
            ),
            Br10(),
            Container(
                padding: EdgeInsets.all(15.0),
                child: listpharmaMethode(size, listePharmaGarde)),
          ],
        ),
      ),
      SingleChildScrollView(
        child: Column(
          children: [
            Br20(),
            Container(
                padding: EdgeInsets.all(15.0),
                child: listpharmaMethode(size, listprochePharma)),
          ],
        ),
      )
    ];
  }

  Widget listpharmaMethode(Size size, List<Pharmas> listePharma) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: listePharma.length,
        itemBuilder: (context, index) {
          Pharmas unePharmacie = listePharma[index];
          return Container(
            // margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
            height: 90,
            width: size.width,
            child: InkWell(
              onTap: () {
                ClassUtils.navigateTo(
                    context,
                    PharmacieDetails(
                      unePharmacie: unePharmacie,
                      userResponse: userResponse,
                    ));
              },
              child: Row(
                children: [
                  Container(
                    height: size.width / 6.5,
                    width: size.width / 6.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.5),
                        image: DecorationImage(
                            image:
                                CachedNetworkImageProvider(unePharmacie.photo!),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Br5(),
                        Text(
                          unePharmacie.nom!,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Br2(),
                        Expanded(
                          child: Text(
                            unePharmacie.adresse!,
                            softWrap: true,
                            style: TextStyle(fontSize: 11),
                            maxLines:
                                2, // Permet de limiter le texte à deux lignes
                            overflow: TextOverflow
                                .ellipsis, // Optionnel: affiche des points de suspension si le texte dépasse deux lignes
                          ),
                        ),
                        Br2(),
                        Text(
                          '${unePharmacie.distance!} km',
                          style: TextStyle(fontSize: 11, color: kBlack),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  // List<int> extractPharmacyIds(String jsonString) {
  //   List<dynamic> idStrings = jsonDecode(jsonString);
  //   return idStrings.map((idString) => int.parse(idString)).toList();
  // }
}
