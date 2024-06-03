// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/categorie_blog.dart';
import 'package:kondjigbale/models/categorie_conseil.dart';
import 'package:kondjigbale/models/menu.dart';
import 'package:kondjigbale/models/menu_response.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/views/home/menu/actualite_page.dart';
import 'package:kondjigbale/views/home/menu/agenda_page.dart';
import 'package:kondjigbale/views/home/menu/conseil_page.dart';
import 'package:kondjigbale/views/home/menu/notification.dart';
import 'package:kondjigbale/views/home/menu/pharmacie_page.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';

import '../../../helpers/manager/default_manager.dart';
import '../../../helpers/utils/lat_long.dart';
import '../../../models/local/default_data.dart';
import '../../../models/local/position_lat_long.dart';

class AllMenu extends StatefulWidget {
  AllMenu({super.key, required this.uIdentifiant, required this.userResponse});
  String? uIdentifiant;
  User? userResponse;
  @override
  State<AllMenu> createState() => _AllMenuState();
}

class _AllMenuState extends State<AllMenu> {
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  List<Menu> lesMenu = [];
  int loadingStatus = 0;
  bool ischecked = true;
  // get menu list
  Future<void> getMenuList(String uIdentifiant) async {
    final Map<String, String> dataMenu = {
      'u_identifiant': uIdentifiant,
    };
    MenuResponse listeMenu = await ApiRepository.listAllMenu(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          lesMenu = listeMenu.information!;
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
        listeMenu.message,
      );
    }
  }

  // launch Api
  Future<void> launchAllfunction() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      getMenuList(widget.uIdentifiant!);
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

  DefaultData? _defaultData;
  void _loadData() {
    DefaultData? data = DataManager.getDefaultData();
    setState(() {
      _defaultData = data;
    });
    print(_defaultData!.deviceId);
  }

  PositionLatLong? devicePosition;
  loadDeviceInfo() async {
    devicePosition = await PositionAllInfo().getDevicePosition();

    print(devicePosition!.latitude);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    launchAllfunction();
    _loadData();
    loadDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    final providerListes = Provider.of<ListesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Br10(),
              // Texte descriptif
              Center(
                child: const Text(
                  "Tous les services",
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
                      Text("Chargement des services en cours")
                    ],
                  ),
                )
              else
                menuCard(
                    categoryblog: providerListes.categoriesBlog,
                    userresponse: widget.userResponse,
                    categoriesConseil: providerListes.categoriesConseil)
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard(
      {List<CategorieBlog>? categoryblog,
      User? userresponse,
      List<CategorieConseil>? categoriesConseil}) {
    List<Menu> filteredMenu = lesMenu
        .where((unMenu) => unMenu.etat == '1' || unMenu.etat == '0')
        .toList();

    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      shrinkWrap: true,
      children: List.generate(filteredMenu.length, (index) {
        Menu unMenu = filteredMenu[index];
        return Padding(
          padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
          child: InkWell(
            onTap: () {
              if (unMenu.etat == '1') {
                if (unMenu.typeMenu == "1") {
                  _navigate_menu(unMenu.codeMenu!,
                      categoryblog: categoryblog,
                      userresponse: userresponse,
                      categoriesConseil: categoriesConseil);
                } else {
                  print('Menu sécial');
                }
              } else {
                if (unMenu.etat == '0') {
                  CustomSoonDialog(context);
                }
              }
            },
            child: Card(
              elevation: 0.0,
              color: Colors.grey.withOpacity(0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: unMenu.icone!,
                    fit: BoxFit.cover,
                    width: 45,
                    placeholder: (context, url) => CardLoading(
                      height: 50,
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                    ),
                    errorWidget: (context, url, error) => SizedBox(
                      width: 50,
                      child: Image.asset(ICON),
                    ),
                  ),
                  Br5(),
                  unMenu.etat == '2'
                      ? const SizedBox()
                      : Text(
                          unMenu.nomMenu!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black),
                        )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  _navigate_menu(String code,
      {List<CategorieBlog>? categoryblog,
      User? userresponse,
      List<CategorieConseil>? categoriesConseil}) async {
    switch (code) {
      case 'M001':
        ClassUtils.navigateTo(
            context,
            AgendaPage(
              userResponse: widget.userResponse,
              data: _defaultData,
              devicePosition: devicePosition,
            ));
        break;
      case 'M002':
        ClassUtils.navigateTo(
            context,
            PharmaPage(
              data: _defaultData,
              devicePosition: devicePosition,
            ));
        break;
      case 'M003':
        ClassUtils.navigateTo(
            context,
            ConseilPage(
              categorieconseil: categoriesConseil,
              userResponse: widget.userResponse,
              data: _defaultData,
              devicePosition: devicePosition,
            ));
        break;
      case 'M004':
        ClassUtils.navigateTo(
            context,
            ActuPage(
              categoryblog: categoryblog,
              userResponse: userresponse,
              data: _defaultData,
              devicePosition: devicePosition,
            ));
        break;
      case 'M005':
        print('555');
        break;
      case 'M006':
        ClassUtils.navigateTo(context, NotifactionPage());
        break;
      case 'M007':
        print('777');
        break;
      case 'M008':
        print('888');
        break;
      case 'M009':
        print('999');
        break;
      default:
        print('Code non reconnu');
        break;
    }
  }
}
