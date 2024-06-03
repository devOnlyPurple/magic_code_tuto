// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/about.dart';
import 'package:kondjigbale/models/groupe_sanguin.dart';
import 'package:kondjigbale/models/response_login.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/models/ville.dart';
import 'package:kondjigbale/models/ville_response.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/providers/user_provider.dart';
import 'package:kondjigbale/views/adresse/home_adresse.dart';
import 'package:kondjigbale/views/home/profil/about_page.dart';
import 'package:kondjigbale/views/home/profil/change_password.dart';
import 'package:kondjigbale/views/home/profil/profil_user.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';

import '../../../helpers/manager/default_manager.dart';
import '../../../models/local/default_data.dart';

class ProfilMain extends StatefulWidget {
  const ProfilMain({super.key});

  @override
  State<ProfilMain> createState() => _ProfilMainState();
}

class _ProfilMainState extends State<ProfilMain> {
  List<Ville> listville = [];
  int loadingStatus = 0;
  late User userResponse = User(prenoms: "");
  final FlutterLocalization localization = FlutterLocalization.instance;
  late String _currentLocale;

  String _selectlang = '';
  final ClassUtils classUtils = ClassUtils();
  final storage = FlutterSecureStorage();
  final ClassUtils _classUtils = ClassUtils();
  String pdentifiant = '';
  String Uidentifiant = '';
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  List<String> langOption = ['fr', 'en'];
  About aboutInfo = About(contacts: "");
  List<About> data = [];
  String logo = '';
  String nomsociete = '';
  String firstdes = '';
  String version = '';
  String contacts = '';
  DefaultData? _defaultData;
  void _loadData() {
    DefaultData? data = DataManager.getDefaultData();
    setState(() {
      _defaultData = data;
    });
    print('_defaultData!.deviceId');
    print(_defaultData!.langue);
    print('_defaultData!.deviceId');
  }

  Future<void> getAbout() async {
    try {
      final String response =
          await rootBundle.loadString('assets/json/about_kdg.json');
      final jsonData = json.decode(response);
      final results = jsonData as Map<String, dynamic>;
      final aboutData = About.fromJson(results);
      setState(() {
        data = [aboutData];
        aboutInfo = aboutData;
        logo = data[0].logo!;
      });
      // print(jsonData);
    } catch (error) {
      debugPrint('Erreur lors de la recupperation de l\'api => $error');
    }
  }

  Future<void> getVilleList(String pdentifiant) async {
    final Map<String, String> dataMenu = {
      'p_identifiant': pdentifiant,
    };
    VilleResponse listeMenu = await ApiRepository.listVille(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          listville = listeMenu.information!;
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

  Future<void> getUserInfo(String UIdentifant) async {
    final Map<String, String> dataMenu = {
      'u_identifiant': UIdentifant,
    };
    LoginResponse listeMenu = await ApiRepository.getUserInfo(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          userResponse = listeMenu.information!;
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

  Future<void> launchAllfunction(
      String pIdentifiant, String uIdentifiant) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      getVilleList(pIdentifiant);
      getUserInfo(uIdentifiant);
    } else {
      print("no connexion");
      CustomErrorDialog(
        context,
        content: "Vérifiez votre connexion internet",
        buttonText: "Réessayez",
        onPressed: () {
          launchAllfunction(uIdentifiant, uIdentifiant);
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
    _loadData();
    _currentLocale = localization.currentLocale!.languageCode;

    _selectlang = _currentLocale;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final userInfo = Provider.of<UsersProvider>(context);
    final listeProvider = Provider.of<ListesProvider>(context);
    print(userInfo.userResponse.toJson());
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Br10(),
            Center(
              child: const Text(
                "Mon compte",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
              ),
            ),
            Br30(),
            infoBox(size, userInfo.userResponse),
            Br20(),
            getOptionContent('assets/icons/location.svg', "Mes adresses", 0,
                page: AdresseHome(
                  userResponse: userInfo.userResponse,
                )),
            Br5(),
            getOptionContent('assets/icons/user.svg', "Modifier mon compte", 1,
                apiPays: listeProvider.listcountry,
                groupesangun: listeProvider.groupeSanguins),
            Br5(),
            getOptionContent(
                'assets/icons/password.svg', "Modifier mon mot de passe", 2,
                page: PasswordUpdatePage(
                  useresponse: userResponse,
                )),
            Br5(),
            getOptionContent(
                'assets/icons/langue.svg', "Modifier la langue", 3),
            Br5(),
            getOptionContent('assets/icons/about.svg', "A propos", 4),
            Br5(),
            getOptionContent('assets/icons/logout.svg', "Déconnexion", 5,
                apiPays: listeProvider.listcountry,
                listSexe: listeProvider.sexe),
          ],
        ),
      )),
    );
  }

  Container infoBox(Size size, User userResponse) {
    return Container(
      height: 90,
      width: size.width,
      decoration: BoxDecoration(
          color: Kprimary, borderRadius: BorderRadius.circular(15.0)),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          CircleAvatar(
            backgroundColor: Ksecondary, // Couleur de fond du cercle
            radius: 35, // Rayon du cercle
            child: Text(
              userResponse.prenoms![0].toUpperCase() +
                  userResponse.nom![0]
                      .toUpperCase(), // Texte à afficher à l'intérieur du cercle
              style: TextStyle(
                color: Colors.white, // Couleur du texte
                fontSize: 30, // Taille de la police du texte
                fontWeight: FontWeight.bold, // Gras
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${capitalizeFirstLetter(userResponse.prenoms!)} ${userResponse.nom!.toUpperCase()}',
                style: TextStyle(color: kWhite, fontWeight: FontWeight.w500),
              ),
              if (userResponse.email!.isNotEmpty)
                Column(
                  children: [
                    Text(userResponse.email!,
                        style: TextStyle(
                            color: kWhite, fontWeight: FontWeight.w500)),
                  ],
                ),
              Br3(),
              Text(
                userResponse.username!,
                style: TextStyle(color: kWhite, fontWeight: FontWeight.w500),
              ),
            ],
          )
        ],
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input; // Vérifie si la chaîne est vide

    // Retourne la chaîne avec le premier caractère converti en majuscule et les autres caractères inchangés
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  Widget getOptionContent(String icon, String text, int index,
      {Widget? page,
      List<Country>? apiPays,
      List<Sexe>? listSexe,
      List<GroupeSanguin>? groupesangun}) {
    List<int> tableau = [0, 1, 2];

    int langueIndex = 3;
    return InkWell(
      onTap: () async {
        if (tableau.contains(index)) {
          if (index == 1) {
            final responseAdresse = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfilPage(
                        userResponse: userResponse,
                        apiPays: apiPays,
                        groupesangun: groupesangun,
                        villeList: listville)));
            setState(() {
              if (responseAdresse == 1) {
                _loadInformation();
                print(1);
              }
            });
          } else {
            ClassUtils.navigateTo(context, page!);
          }
        } else {
          if (index == langueIndex) {
            _showBottomModal(context);
          } else {
            if (index == 4) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AboutPage(
                    data: data,
                  );
                },
              );
            } else {
              CustomChoixDialog(context,
                  title: "Déconnexion",
                  content:
                      "Vous êtes sur le point de vous déconnecter. Veuillez cliquer sur \"Non\" pour revenir en arrière ou \"Oui\" pour continuer",
                  acceptText: "Oui",
                  cancelText: "Non", cancelPress: () {
                Navigator.of(context).pop();
              }, acceptPress: () {
                Navigator.of(context).pop();
                CustomLoading(context, status: "Déconnexion en cours...");
                _disconnect(apiPays, listSexe);
              });
            }
          }
        }
      },
      child: SizedBox(
        height: 45,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              SvgPicture.asset(
                icon,
                colorFilter: index == 5
                    ? ColorFilter.mode(Colors.red, BlendMode.srcIn)
                    : ColorFilter.mode(Colors.black, BlendMode.srcIn),
                height: 18,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                text,
                style: TextStyle(
                    fontSize: 15,
                    color: index == 5 ? Colors.red : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              if (index == langueIndex)
                Row(
                  children: [
                    Text(
                      _getlanguage(),
                      style: TextStyle(color: kBlack),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              if (index != 5)
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 13,
                  ),
                ),
              SizedBox(
                width: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _loadInformation() async {
    final user = Provider.of<UsersProvider>(context, listen: false);
    _classUtils.getUserInformation().then((value) {
      setState(() {
        userResponse = value;
        pdentifiant = value.paysKey!;
        Uidentifiant = value.token!;
        user.userInfo = value;
      });
      launchAllfunction(pdentifiant, Uidentifiant);
      getAbout();
    });
  }

  _disconnect(List<Country>? apiPays, List<Sexe>? listSexe) async {
    await storage.write(key: 'connectionStatus', value: 'disconnected');
    Navigator.pop(context);
    GoRouter.of(context).go('/login',
        extra: <String, dynamic>{'apiPays': apiPays, "listSexe": listSexe});
  }

  void _showBottomModal(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: size.height / 4,
          width: size.width, // Hauteur du modal
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Center(
                      child: Text(LocaleData.firsText.getString(context),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(left: 8.0, bottom: 0.0),
                  height: 40,
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButtonFormField<String>(
                      value: _selectlang, // Valeur sélectionnée
                      items: langOption.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              if (value == 'fr')
                                Row(
                                  children: [
                                    Center(
                                      child: CountryFlag.fromCountryCode(
                                        'fr',
                                        height: 28,
                                        width: 18,
                                        borderRadius: 8,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Français',
                                    ),
                                    // Text('data')
                                  ],
                                )
                              else
                                Row(
                                  children: [
                                    Center(
                                      child: CountryFlag.fromCountryCode(
                                        'GB',
                                        height: 28,
                                        width: 18,
                                        borderRadius: 8,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'English',
                                    ),
                                    // Text('data')
                                  ],
                                )
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        _setLocal(value!);
                      },
                      decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.info_outline),
                          // prefixIcon: null,
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                              EdgeInsets.fromLTRB(7.0, 0.0, 10.0, 11.0),
                          // labelText: 'Selectionnez le type',
                          hintText: 'Selectionnez le type'),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        );
      },
    );
  }

  void _setLocal(String value) async {
    localization.translate(value);
    DataManager.updateLanguage(value);
    await storage.write(key: 'locale', value: value);
    setState(() {
      _currentLocale = value;
    });
    final String? localiser = await storage.read(key: 'locale');
    print(localiser);
  }

  _getlanguage() {
    var langue = '';
    if (_currentLocale == 'fr') {
      langue = 'Français';
    } else {
      langue = LocaleData.langueEn.getString(context);
    }
    return langue;
  }
}
