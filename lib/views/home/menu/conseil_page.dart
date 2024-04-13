// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';

import 'package:kondjigbale/models/categorie_conseil.dart';
import 'package:kondjigbale/models/conseil.dart';
import 'package:kondjigbale/models/conseil_response.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/views/conseil/conseil_save.dart';
import 'package:kondjigbale/views/conseil/details_conseil.dart';
import 'package:kondjigbale/widget/empty_page.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:share_plus/share_plus.dart';

class ConseilPage extends StatefulWidget {
  ConseilPage(
      {super.key, required this.categorieconseil, required this.userResponse});
  List<CategorieConseil>? categorieconseil;
  User? userResponse;
  @override
  State<ConseilPage> createState() => _ConseilPageState();
}

class _ConseilPageState extends State<ConseilPage> {
  int loadingStatus = 0;
  int _selectIndex = -1;
  // int likeQuantity = 0;
  int likecount = 3;
  int shareQuantity = 0;
  List<Conseil> lesConseils = [];
  List<Conseil> lesSaveConseil = [];
  String keyblog = '';
  Future<void> getConseil(String keyBlog) async {
    final Map<String, String> dataconseil = {
      'u_identifiant': widget.userResponse!.token!,
      'e_identifiant': '',
      'cat_identifiant': keyBlog,
      'type_liste': '0',
      'key_conseil': '',
    };

    ConseilResponse listeConseil = await ApiRepository.listConseil(dataconseil);

    if (listeConseil.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          lesConseils = listeConseil.information!;
          loadingStatus = 1;
          for (Conseil conseil in lesConseils) {
            if (conseil.isLike == 1) {
              conseil.isLiking = true;
            }
            if (conseil.isSave == 1) {
              conseil.isSaving = true;
            }
          }
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

  final ConnectivityChecker _connectivity = ConnectivityChecker();
  Future<void> launchAllfunction() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      getConseil(keyblog);
      getSaveConseil(keyblog);
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
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
          ),
        ),
        title: Text(
          "Conseils",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: const Icon(Icons.calendar_month),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {},
            child: const Icon(Icons.refresh),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              ClassUtils.navigateTo(
                  context,
                  SaveConseil(
                    lesSaveConseil:lesSaveConseil,
                    userResponse: widget.userResponse,
                  ));
            },
            child: const Icon(Icons.save_outlined),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Br10(),
                conseilCards(size, widget.categorieconseil!),
                Br20(),
                Container(
                    child: loadingStatus == 0
                        ? Center(
                            // Affichez un indicateur de chargement tant que loadingStatus est égal à 0
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 50),
                                CircularProgressIndicator(
                                  backgroundColor: Kprimary,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey),
                                ),
                                SizedBox(height: 10),
                                Text("Chargement des conseils en cours"),
                              ],
                            ),
                          )
                        : ConseilList(lesConseils, size))
              ],
            )),
      ),
    );
  }

  Widget conseilCards(Size size, List<CategorieConseil> catConseil) {
    return SizedBox(
        height: 60,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: catConseil.length,
            itemBuilder: (context, index) {
              CategorieConseil uneCategorie = catConseil[index];
              bool isSelected = index == _selectIndex;

              return InkWell(
                onTap: () {
                  setState(() {
                    loadingStatus = 0;
                    if (index == _selectIndex) {
                      _selectIndex = -1;
                      keyblog = '';
                    } else {
                      _selectIndex = index;
                      keyblog = uneCategorie.keyCategorie!;
                    }
                    getConseil(keyblog);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0,top: 5.0,bottom: 5.0),
                  child: Container(
                    width: size.width / 3.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: isSelected
                            ? Kprimary
                            : Colors.transparent, // Bordure verte
                        width: 3.0, // Épaisseur de la bordure
                      ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  uneCategorie.image!),
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.darken))),
                      width: size.width / 5,
                      child: Center(
                        child: Text(
                          uneCategorie.nom!,
                          style: const TextStyle(
                              color: kWhite, fontWeight: FontWeight.w600,fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  SizedBox ConseilList(List<Conseil> categorieConseil, Size size) {
    late int likeQuantity;

    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          if (categorieConseil.isEmpty)
            EmptyPage(title: 'Aucun.s conseil.s disponible')
          else
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: categorieConseil.length,
                itemBuilder: (context, i) {
                  Conseil uneCategorieConseil = categorieConseil[i];
                  likeQuantity = uneCategorieConseil.allLike!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        ClassUtils.navigateTo(
                            context,
                            ConseilDetails(
                              unConseil: uneCategorieConseil,
                              userResponse: widget.userResponse,
                              onLike: (String keyconseil) {
                                _likeDislikeConseil(keyconseil);
                              },
                              onSave: (String keyconseil) {
                                _saveConseil(keyconseil);
                              },
                              onShare: (String keyconseil) {
                                _shareConseil(keyconseil);
                              },
                            ));
                      },
                      child: Container(
                        height: 100,
                        width: size.width,
                        decoration: BoxDecoration(
                          // color: Colors.grey.shade100,
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 5),
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              width: size.width / 6.5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          uneCategorieConseil.coverImage!),
                                      fit: BoxFit.fill)),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        child: uneCategorieConseil.typeMedia == 1
                                            ? Icon(
                                                Icons.image_outlined,
                                                color: Colors.black,
                                              )
                                            : uneCategorieConseil.typeMedia == 2
                                                ? Icon(
                                                    Icons.videocam_outlined,
                                                    color: Colors.black,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .spatial_audio_off_outlined,
                                                    color: Colors.black,
                                                  ),
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Text(
                                          uneCategorieConseil.titre!,
                                          softWrap: true,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Br5(),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/user.svg',
                                        height: 15,
                                        color: kBlack,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        uneCategorieConseil.expert!.name!,
                                        softWrap: true,
                                        style: TextStyle(color: kBlack),
                                      ),
                                    ],
                                  ),
                                  Br10(),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (uneCategorieConseil.isLiking ==
                                                true) {
                                              uneCategorieConseil
                                                  .allLike = (uneCategorieConseil
                                                          .allLike ??
                                                      0) -
                                                  1; // Incrémenter le nombre de likes
                                              uneCategorieConseil.isLiking =
                                                  false; // Mettre à jour l'état de liking
                                            } else {
                                              uneCategorieConseil
                                                  .allLike = (uneCategorieConseil
                                                          .allLike ??
                                                      0) +
                                                  1; // Décrémenter le nombre de likes
                                              uneCategorieConseil.isLiking =
                                                  true; // Mettre à jour l'état de liking
                                            }
                                          });
                                          _likeDislikeConseil(
                                              uneCategorieConseil.keyConseil!);
                                        },
                                        child: SizedBox(
                                          child: Row(
                                            children: [
                                              Icon(
                                                uneCategorieConseil.isLiking ==
                                                        true
                                                    ? Icons.favorite
                                                    : Icons
                                                        .favorite_outline_outlined,
                                                size: 18,
                                                color: uneCategorieConseil
                                                            .isLiking ==
                                                        true
                                                    ? kRed
                                                    : Colors.black,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text((uneCategorieConseil.allLike)
                                                  .toString())
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      InkWell(
                                        onTap: () async {
                                          try {
                                            // Appel de la méthode Share.share pour partager le lien
                                            await Share.share(
                                                uneCategorieConseil.shareLink!);
                                            _shareConseil(
                                                uneCategorieConseil.keyConseil!);
                                            // Si le partage est réussi, cela signifie que l'utilisateur a appuyé sur le bouton de partage
                                            print(
                                                "L'utilisateur a partagé l'actualité");
                                          } catch (e) {
                                            // En cas d'erreur lors du partage
                                            print("Erreur lors du partage : $e");
                                          }
                                        },
                                        child: SizedBox(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.share_outlined,
                                                size: 18,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(uneCategorieConseil.shares
                                                  .toString())
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (uneCategorieConseil.isSaving ==
                                                true) {
                                              uneCategorieConseil.isSaving =
                                                  false;
                                            } else {
                                              uneCategorieConseil.isSaving = true;
                                            }
                                          });
                                          _saveConseil(
                                              uneCategorieConseil.keyConseil!);
                                        },
                                        child: Icon(
                                          uneCategorieConseil.isSaving == true
                                              ? Icons.bookmark
                                              : Icons.bookmark_border_outlined,
                                          size: 18,
                                          color:
                                              uneCategorieConseil.isSaving == true
                                                  ? Kprimary
                                                  : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
        ],
      ),
    );
  }

  _likeDislikeConseil(String keyConseil) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataconseil = {
        'u_identifiant': widget.userResponse!.token!,
        'key_conseil': keyConseil,
      };

      ConseilResponse listeConseil =
          await ApiRepository.likeDislikeConseil(dataconseil);

      print(listeConseil.status);
      if (listeConseil.status == API_SUCCES_STATUS) {
        getConseil(keyblog);
      } else {
        var message = listeConseil.message.toString();
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

  _shareConseil(String keyConseil) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataconseil = {
        'u_identifiant': widget.userResponse!.token!,
        'key_conseil': keyConseil,
      };

      ConseilResponse listeConseil =
          await ApiRepository.shareConseil(dataconseil);

      print(listeConseil.status);
      if (listeConseil.status == API_SUCCES_STATUS) {
        getConseil(keyblog);
      } else {
        var message = listeConseil.message.toString();
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

  _saveConseil(String keyConseil) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataconseil = {
        'u_identifiant': widget.userResponse!.token!,
        'key_conseil': keyConseil,
      };

      ConseilResponse listeConseil =
          await ApiRepository.saveConseil(dataconseil);

      print(listeConseil.status);
      if (listeConseil.status == API_SUCCES_STATUS) {
        getConseil(keyblog);
      } else {
        var message = listeConseil.message.toString();
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

  Future<void> getSaveConseil(String keyBlog) async {
    final Map<String, String> dataconseil = {
      'u_identifiant': widget.userResponse!.token!,
      'e_identifiant': '',
      'cat_identifiant': keyBlog,
      'type_liste': '1',
      'key_conseil': '',
    };

    ConseilResponse listeConseil = await ApiRepository.listConseil(dataconseil);

    if (listeConseil.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          lesSaveConseil = listeConseil.information!;
          loadingStatus = 1;
          for (Conseil conseil in lesConseils) {
            if (conseil.isLike == 1) {
              conseil.isLiking = true;
            }
            if (conseil.isSave == 1) {
              conseil.isSaving = true;
            }
          }
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
}
