// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
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

import '../../../classe/connect/class_monitoring_internet.dart';
import '../../../helpers/utils/lat_long.dart';
import '../../../models/local/default_data.dart';
import '../../../models/local/position_lat_long.dart';
import '../../../widget/empty_page.dart';
import '../../../widget/internet_dialog.dart';
import '../pharmacies/pharma_methode.dart';

class PharmaPage extends StatefulWidget {
  PharmaPage({super.key, required this.data, required this.devicePosition});
  DefaultData? data;
  PositionLatLong? devicePosition;
  @override
  State<PharmaPage> createState() => _PharmaPageState();
}

class _PharmaPageState extends State<PharmaPage> {
  final List<String> tabTitles = ['De garde', 'A proximité'];
  List<Pharmas> listePharma = [];
  List<Pharmas> listePharmaGarde = [];
  List<Pharmas> listprochePharma = [];
  List<Pharmas> filteredList = [];
  late User userResponse = User(prenoms: "");
  late Garde pharmaGARDE = Garde(pharmacieIds: '');
  final ClassUtils classUtils = ClassUtils();
  final storage = FlutterSecureStorage();
  final ClassUtils _classUtils = ClassUtils();
  int loadingStatus = 0;
  String uIdentifiant = '';
  String jsonString = '';
  late List<int> pharmacyIds;
  UsersProvider userprovider = UsersProvider();
  double latitude = 0.0;
  double longitude = 0.0;
  final TextEditingController _searching = TextEditingController();

  Future<void> getPharaList(String latitude, String longitude) async {
    final Map<String, String> dataMenu = {
      'u_identifiant': userprovider.userResponse.token!,
      "registration_id": widget.data!.registrationId!,
      "lang": widget.data!.langue!,
      "latMember": latitude,
      "longMember": longitude,
      "device_id": widget.data!.deviceId!,
      "device_name": widget.data!.deviceName!,
    };

    print('start-api');
    PharmaciesResponse listeMenu = await ApiRepository.listPharma(dataMenu);
    print('end-api');
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          print('startrecup');

          listePharma = listeMenu.information!.pharmas!;
          loadingStatus = 1;
          listprochePharma = listeMenu.information!.pharmas!;
          listprochePharma.sort((a, b) =>
              double.parse(a.distance!).compareTo(double.parse(b.distance!)));
          pharmaGARDE = listeMenu.information!.garde!;
          jsonString = pharmaGARDE.pharmacieIds!;
          pharmacyIds = jsonDecode(jsonString)
              .map<int>((idString) => int.parse(idString))
              .toList();
          listePharmaGarde = listePharma
              .where((pharmacy) => pharmacyIds.contains(pharmacy.id))
              .toList();

          // proximité
          listePharmaGarde.sort((a, b) =>
              double.parse(a.distance!).compareTo(double.parse(b.distance!)));
          log('proximité');

          log(listprochePharma.toString());
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

  bool _isSearching = false;
  @override
  void initState() {
    // ConnectivitySettings.init(lookupDuration: const Duration(seconds: 30));
    super.initState();
    ConnectivityService().startMonitoring(context, () async {
      await getPharaList(widget.devicePosition!.latitude.toString(),
          widget.devicePosition!.longitude.toString());
      ;
    });
    loadDeviceInfo();
  }

  @override
  void dispose() {
    super.dispose();
    ConnectivityService().dispose();
  }

  PositionLatLong? devicePosition;
  loadDeviceInfo() async {
    devicePosition = await PositionAllInfo().getDevicePosition();
    print(devicePosition!.latitude);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: tabTitles.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: _isSearching == false,
          bottom: TabBar(
            tabs: const [
              Tab(
                text: 'De garde',
              ),
              Tab(
                text: 'A proximité',
              ),
            ],
          ),
          leading: _isSearching == false
              ? InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                  ),
                )
              : null,
          title: _isSearching
              ? searchBox(size)
              : const Text(
                  "Pharmacies",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
          actions: [
            if (_isSearching == false)
              InkWell(
                onTap: () {
                  setState(() {
                    _isSearching = true;
                    filteredList = List.from(listePharmaGarde);
                  });
                },
                child: Icon(
                  Icons.search_outlined,
                  size: 25,
                ),
              ),
            if (_isSearching == false)
              SizedBox(
                width: 10,
              ),
            if (_isSearching == false)
              InkWell(
                onTap: () async {
                  print(1);
                  setState(() {
                    loadingStatus = 0;
                  });
                  await loadDeviceInfo();
                  getPharaList(devicePosition!.latitude.toString(),
                      devicePosition!.longitude.toString());
                },
                child: Icon(
                  Icons.refresh_rounded,
                  size: 25,
                ),
              ),
            if (_isSearching == false)
              SizedBox(
                width: 15,
              ),
          ],
        ),
        // : AppBar(
        //     toolbarHeight: 80,
        //     automaticallyImplyLeading: false,
        //     title: searchBox(size),
        //   ),
        body: TabBarView(
          children:
              _buildTabBarViews(size), // Ajoutez les pages d'onglet réelles ici
        ),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return tabTitles.map((title) => Tab(text: title)).toList();
  }

  List<Widget> _buildTabBarViews(Size size) {
    return [
      SingleChildScrollView(
        child: loadingStatus == 0
            ? Center(
                // Affichez un indicateur de chargement tant que loadingStatus est égal à 0
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(height: 50),
                    CircularProgressIndicator(
                      backgroundColor: Kprimary,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                    SizedBox(height: 10),
                    Text("Chargement des pharmacies en cours"),
                  ],
                ),
              )
            : Column(
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
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                            fontSize: 15),
                      )),
                    ),
                  ),
                  Br10(),
                  Container(
                      padding: EdgeInsets.all(15.0),
                      child: listpharmaMethode(size, listePharmaGarde,
                          _isSearching, filteredList, userResponse)),
                ],
              ),
      ),
      SingleChildScrollView(
        child: Column(
          children: [
            Br20(),
            Container(
                padding: EdgeInsets.all(15.0),
                child: listpharmaMethode(size, listprochePharma, _isSearching,
                    filteredList, userResponse)),
          ],
        ),
      )
    ];
  }

  // Widget listpharmaMethode(Size size, List<Pharmas> listePharma) {
  //   listePharma = _isSearching ? filteredList : listePharma;
  //   if (listePharma.isEmpty) {
  //     return Center(
  //       child: EmptyPage(
  //         title: 'Aucune pharmacie trouvée',
  //         asset: 'assets/images/pharma.png',
  //       ),
  //     );
  //   }
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       physics: NeverScrollableScrollPhysics(),
  //       itemCount: listePharma.length,
  //       itemBuilder: (context, index) {
  //         Pharmas unePharmacie = listePharma[index];
  //         return Container(
  //           // margin: EdgeInsets.all(8.0),
  //           padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
  //           height: 90,
  //           width: size.width,
  //           child: InkWell(
  //             onTap: () {
  //               ClassUtils.navigateTo(
  //                   context,
  //                   PharmacieDetails(
  //                     unePharmacie: unePharmacie,
  //                     userResponse: userResponse,
  //                   ));
  //             },
  //             child: Row(
  //               children: [
  //                 Container(
  //                   height: size.width / 6.5,
  //                   width: size.width / 6.5,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(7.5),
  //                       image: DecorationImage(
  //                           image:
  //                               CachedNetworkImageProvider(unePharmacie.photo!),
  //                           fit: BoxFit.cover)),
  //                 ),
  //                 SizedBox(
  //                   width: 16,
  //                 ),
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Br5(),
  //                       Text(
  //                         unePharmacie.nom!,
  //                         style: TextStyle(
  //                             fontWeight: FontWeight.w600, fontSize: 14),
  //                       ),
  //                       Br2(),
  //                       Text(
  //                         unePharmacie.adresse!,

  //                         style: TextStyle(fontSize: 11),
  //                         // Optionnel: affiche des points de suspension si le texte dépasse deux lignes
  //                       ),
  //                       Br5(),
  //                       Text(
  //                         '${unePharmacie.distance!} km',
  //                         style: TextStyle(fontSize: 11, color: kBlack),
  //                       ),
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  Widget searchBox(Size size) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Br10(),
          TextFormField(
              style: const TextStyle(
                  fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
              controller: _searching,
              onChanged: (value) {
                search = value.toLowerCase();
                filterPharmacies();
              },
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searching.clear();
                      });
                    },
                    icon: Icon(Icons.remove_circle_outline_outlined)),
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
                hintText: 'Rechercher une pharmacie ',
                hintStyle: TextStyle(
                    fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
                prefixText: ' ',
              )),
        ],
      ),
    );
  }

  String search = "";
  void filterPharmacies() {
    setState(() {
      if (search.isNotEmpty) {
        _isSearching = true;
        filteredList = listePharma
            .where((pharmacy) =>
                pharmacy.nom!.toLowerCase().contains(search.toLowerCase()))
            .toList();
      } else {
        _isSearching = false;
        filteredList = listePharma;
      }
    });
  }
}
