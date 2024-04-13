// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/sizeconfig.dart';
import 'package:kondjigbale/models/menu.dart';
import 'package:kondjigbale/models/menu_response.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';

class CustomMenu extends StatefulWidget {
  CustomMenu({super.key, required this.uIdentifiant, required this.stringList});
  String? uIdentifiant;
  List<String>? stringList;
  @override
  State<CustomMenu> createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  List<Menu> lesMenu = [];
  int loadingStatus = 0;
  bool ischecked = true;
  String result = "";
  List<String> codesMenu = [];
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
          result = widget.stringList!.join(',');
          codesMenu = List.from(widget.stringList!);

          for (Menu menu in lesMenu) {
            if (widget.stringList != null &&
                widget.stringList!.contains(menu.codeMenu)) {
              menu.isActive = true;
            } else {
              menu.isActive = false;
            }
          }
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    launchAllfunction();
  }

  @override
  Widget build(BuildContext context) {
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
                  "Personnaliser mes services",
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
                Column(
                  children: [menuCard(), Br30(), ConfirmButtonMethod()],
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard() {
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
          padding: const EdgeInsets.only(top: 6.0, bottom: 6.0),
          child: InkWell(
            onTap: () {
              setState(() {
                unMenu.isActive = !unMenu.isActive!;
                if (unMenu.isActive == true) {
                  unMenu.isActive = true;
                  codesMenu.add(unMenu.codeMenu!);
                } else {
                  unMenu.isActive = false;

                  codesMenu.remove(unMenu.codeMenu!);
                }

                result = codesMenu.join(',');
              });

              // print(codesMenu);
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: kGrey.withOpacity(0.3),
                      borderRadius: const BorderRadius.all(Radius.circular(7)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: unMenu.icone!,
                          fit: BoxFit.cover,
                          width: 45,
                          placeholder: (context, url) => CardLoading(
                            height: 50,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                          ),
                          errorWidget: (context, url, error) => SizedBox(
                            width: 50,
                            child: Image.asset(ICON),
                          ),
                        ),
                        Br10(),
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
                Positioned(
                  child: Checkbox(
                      value: unMenu.isActive,
                      activeColor: Kprimary,
                      onChanged: (newBool) {
                        setState(() {
                          unMenu.isActive = newBool!;
                          if (unMenu.isActive == true) {
                            unMenu.isActive = true;
                            codesMenu.add(unMenu.codeMenu!);
                          } else {
                            unMenu.isActive = false;
                            codesMenu.remove(unMenu.codeMenu!);
                          }
                          result = codesMenu.join(',');
                        });
                      }),
                  top: 5,
                  left: 3,
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  SizedBox ConfirmButtonMethod() {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: InkWell(
          onTap: () async {
            CustomLoading(context,
                status: "Enregistrement des accès rapides en cours...");

            _addShorcuts(result);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 14,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Enrégistrer mes choix",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ));
  }

  _addShorcuts(String menuCodes) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataMenu = {
        'u_identifiant': widget.uIdentifiant!,
        'code_menus': menuCodes,
      };
      MenuResponse listeMenu = await ApiRepository.addShorcut(dataMenu);
      Navigator.pop(context);
      if (listeMenu.status == API_SUCCES_STATUS) {
        Navigator.of(context).pop(1);
        UiSnackbar.showSnackbar(context,
            "Vos accès rapides ont été personnalisés avec succès", true);
        if (mounted) {
          setState(() {});
        }
      } else {
        print(
          listeMenu.message,
        );
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
