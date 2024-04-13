// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/categorie_blog.dart';
import 'package:kondjigbale/models/categorie_conseil.dart';
import 'package:kondjigbale/models/conseil.dart';
import 'package:kondjigbale/models/conseil_response.dart';
import 'package:kondjigbale/models/menu.dart';
import 'package:kondjigbale/models/menu_response.dart';
import 'package:kondjigbale/models/menu_special_content.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/providers/listes_provider.dart';

import 'package:kondjigbale/providers/user_provider.dart';
import 'package:kondjigbale/views/home/menu/actualite_page.dart';
import 'package:kondjigbale/views/home/menu/agenda_page.dart';
import 'package:kondjigbale/views/home/menu/all_menu.dart';
import 'package:kondjigbale/views/home/menu/conseil_page.dart';
import 'package:kondjigbale/views/home/menu/custom_menu.dart';
import 'package:kondjigbale/views/home/menu/notification.dart';
import 'package:kondjigbale/views/home/menu/pharmacie_page.dart';
import 'package:kondjigbale/views/home/profil/main_profil.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  late User userResponse = User(prenoms: "");
  final ClassUtils classUtils = ClassUtils();
  final storage = FlutterSecureStorage();
  final ClassUtils _classUtils = ClassUtils();
  int loadingStatus = 0;
  List<Conseil> lesConseils = [];
  List<String> stringList = [];
  List<Menu> lesMenu = [];
  late MenuSpecialResponse specialContent =
      MenuSpecialResponse(information: '');
  List images = [
    {"id": 1, "images_path": 'assets/images/first.jpg'},
    {"id": 2, "images_path": 'assets/images/two.jpg'},
    {"id": 3, "images_path": 'assets/images/tree.jpg'},
  ];
  String uIdentifiant = '';

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  Future<void> getConseil(String uIdentifant) async {
    final Map<String, String> dataconseil = {
      'u_identifiant': uIdentifant,
      'e_identifiant': '',
      'cat_identifiant': '',
      'type_liste': '0',
      'key_conseil': '',
    };

    ConseilResponse listeConseil = await ApiRepository.listConseil(dataconseil);

    if (listeConseil.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          lesConseils = listeConseil.information!;
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
        listeConseil.message,
      );
    }
  }

// get menu list
  Future<void> getMenuList(String uIdentifiant) async {
    final Map<String, String> dataMenu = {
      'u_identifiant': uIdentifiant,
    };
    MenuResponse listeMenu = await ApiRepository.listMenu(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        print('..................');
        print(listeMenu.information!.length);
        print('...........................');

        setState(() {
          lesMenu = listeMenu.information!;
          loadingStatus = 1;
          for (Menu menu in lesMenu) {
            stringList.add(menu.codeMenu!);
          }
          print(stringList);
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

  Future<void> launchAllfunction(String uIdentifiant) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      getConseil(uIdentifiant);
      getMenuList(uIdentifiant);
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
    final userInfo = Provider.of<UsersProvider>(context);
    final providerListes = Provider.of<ListesProvider>(context);

    print(userInfo.userResponse.nom);
    print(providerListes.categoriesConseil[0].nom);

    return Scaffold(
      appBar: appBarMethod(
          userInfo.userResponse.prenoms!, userInfo.userResponse.nom!),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // Br20(),
              horizontalList(size),
              Br20(),
              titleAndMore(),
              Br5(),
              if (lesConseils.isNotEmpty) CatConseilList(lesConseils, size),
              Br20(),
              rapidAccess(),
              Br10(),
              Column(
                children: [
                  if (loadingStatus == 0)
                    Center(
                      // Affichez un indicateur de chargement tant que loadingStatus est égal à 0
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                  else
                    reoardableCard(
                        categoryblog: providerListes.categoriesBlog,
                        userresponse: userResponse,
                        categorieConseil: providerListes.categoriesConseil),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBarMethod(String name, String firstname) {
    return AppBar(
      title: SizedBox(
        height: 40,
        child: Image.asset(LOGO_LONG),
      ),
      actions: [
        InkWell(
          onTap: () {
            ClassUtils.navigateTo(context, ProfilMain());
          },
          child: CircleAvatar(
            backgroundColor: Kprimary, // Couleur de fond du cercle
            radius: 23, // Rayon du cercle
            child: Text(
              name[0].toUpperCase() +
                  firstname[0]
                      .toUpperCase(), // Texte à afficher à l'intérieur du cercle
              style: TextStyle(
                color: Colors.white, // Couleur du texte
                fontSize: 20, // Taille de la police du texte
                fontWeight: FontWeight.bold, // Gras
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        )
      ],
    );
  }

  Widget horizontalList(Size size) {
    return Stack(
      children: [
        InkWell(
          onTap: () {},
          child: CarouselSlider(
            items: images
                .map(
                  (item) => Container(
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: AssetImage(item['images_path']),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.3),
                                BlendMode.darken))),
                  ),
                )
                .toList(),
            carouselController: carouselController,
            options: CarouselOptions(
              height: 200,
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlay: true,
              aspectRatio: 2,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: 7,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3.0,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: currentIndex == entry.key
                          ? Colors.white
                          : Colors.black54),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  SizedBox CatConseilList(List<Conseil> categorieConseil, Size size) {
    return SizedBox(
      height: 110,
      width: size.width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categorieConseil.length,
          itemBuilder: (context, i) {
            Conseil uneCategorieConseil = categorieConseil[i];
            return Card(
              elevation: 0.0,
              color: kRose,
              child: Column(
                children: [
                  SizedBox(
                      height: 70,
                      width: size.width / 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: uneCategorieConseil.coverImage!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CardLoading(
                            height: 100,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          errorWidget: (context, url, error) =>
                              const CardLoading(
                            height: 100,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      )),
                  Br10(),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 4, right: 4),
                    child: Text(
                      uneCategorieConseil.titre!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 8,
                          color: kBlack),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Widget _buildConseilShimmer() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: ListView.builder(
            itemCount: 4,
            itemBuilder: (context, i) {
              return Card(
                color: kRose,
                child: Column(
                  children: [
                    SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                        ))
                  ],
                ),
              );
            }));
  }

  // charger les donne de l'utilisateur

  Future _loadInformation() async {
    final user = Provider.of<UsersProvider>(context, listen: false);
    _classUtils.getUserInformation().then((value) {
      setState(() {
        userResponse = value;
        uIdentifiant = value.token!;
        user.userInfo = value;
      });
      launchAllfunction(uIdentifiant);
    });
  }

  Widget titleAndMore() {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Icon(
              Icons.refresh,
              color: Colors.black,
              size: 17,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Nos derniers conseils",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Spacer(),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Text("Voir plus"),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget rapidAccess() {
    return Container(
      child: Row(
        children: [
          InkWell(
            onTap: () async {
              final responseHome = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CustomMenu(
                            uIdentifiant: uIdentifiant,
                            stringList: stringList,
                          )));
              setState(() {
                if (responseHome == 1) {
                  loadingStatus = 0;
                  stringList = [];
                  getMenuList(uIdentifiant);
                }
              });
            },
            child: Icon(
              Icons.filter_list_outlined,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Accès rapides",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              Text(
                "Appui long sur un service pour le déplacer ",
                style: TextStyle(fontSize: 11, color: kBlack),
              ),
            ],
          ),
          Spacer(),
          InkWell(
              onTap: () {
                ClassUtils.navigateTo(
                    context,
                    AllMenu(
                      uIdentifiant: uIdentifiant,
                      userResponse: userResponse,
                    ));
              },
              child: Icon(
                Icons.apps,
                color: Colors.black,
                size: 20,
              ))
        ],
      ),
    );
  }

  _navigate_menu(String code,
      {List<CategorieBlog>? categoryblog,
      User? userresponse,
      List<CategorieConseil>? categoriesConseil}) async {
    switch (code) {
      case 'M001':
        ClassUtils.navigateTo(context, AgendaPage(userResponse: userresponse));
        break;
      case 'M002':
        ClassUtils.navigateTo(context, PharmaPage());
        break;
      case 'M003':
        ClassUtils.navigateTo(
            context,
            ConseilPage(
              categorieconseil: categoriesConseil,
              userResponse: userresponse,
            ));
        break;
      case 'M004':
        ClassUtils.navigateTo(context,
            ActuPage(categoryblog: categoryblog, userResponse: userresponse));
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

  Widget reoardableCard(
      {List<CategorieBlog>? categoryblog,
      User? userresponse,
      List<CategorieConseil>? categorieConseil}) {
    return ReorderableGridView.count(
      padding: EdgeInsets.all(0.0),
      crossAxisCount: 3,
      // childAspectRatio: 1.0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      onReorder: (int oldIndex, int newIndex) {
        String newOrder = '';

        setState(() {
          final Menu item = lesMenu.removeAt(oldIndex);
          lesMenu.insert(newIndex, item);
          for (Menu menu in lesMenu) {
            if (newOrder != "") newOrder += ",";
            newOrder += '${menu.codeMenu}';
          }
          stringList = newOrder.split(',');
        });
        print(newOrder);
        _addShorcuts(newOrder);
      },
      children: lesMenu
          .where((item) => item.etat == '1' || item.etat == '0')
          .map((Menu item) {
        return Container(
          key: ValueKey(item.codeMenu),
          // color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: InkWell(
              onTap: () {
                if (item.etat == '1') {
                  if (item.typeMenu == "1") {
                    _navigate_menu(item.codeMenu!,
                        categoryblog: categoryblog,
                        userresponse: userresponse,
                        categoriesConseil: categorieConseil);
                  } else {
                    CustomLoading(context, status: "Chargement...");
                    _showSpecial(item.nomMenu!);
                  }
                } else {
                  if (item.etat == '0') {
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
                        imageUrl: item.icone!,
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
                      Text(
                        item.nomMenu!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 11,
                            color: Colors.black87),
                      )
                    ],
                  )),
            ),
          ),
        );
      }).toList(),
    );
  }

  _addShorcuts(String menuCodes) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataMenu = {
        'u_identifiant': uIdentifiant,
        'code_menus': menuCodes,
      };
      MenuResponse listeMenu = await ApiRepository.addShorcut(dataMenu);

      if (listeMenu.status == API_SUCCES_STATUS) {
        if (mounted) {}
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

  _showSpecial(String title) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataMenu = {
        'u_identifiant': uIdentifiant,
      };
      MenuSpecialResponse listeMenu = await ApiRepository.specialMenu(dataMenu);
      Navigator.pop(context);
      if (listeMenu.status == API_SUCCES_STATUS) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.8, // Taille fixe pour le contenu HTML
                  height: 250,
                  child: SingleChildScrollView(
                    child: Html(
                      data: specialContent.information ?? '',
                      style: {
                        'html': Style(textAlign: TextAlign.justify),
                      },
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Kgreen.withOpacity(0.2)),
                    child: const Text(
                      "Fermer",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Kgreen),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
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
