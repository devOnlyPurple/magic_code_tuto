// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/actu_response.dart';
import 'package:kondjigbale/models/actualite.dart';
import 'package:kondjigbale/models/categorie_blog.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/views/blog/detail_blog.dart';
import 'package:kondjigbale/widget/empty_page.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';

class ActuPage extends StatefulWidget {
  ActuPage({super.key, required this.categoryblog, required this.userResponse});
  List<CategorieBlog>? categoryblog;
  User? userResponse;
  @override
  State<ActuPage> createState() => _ActuPageState();
}

class _ActuPageState extends State<ActuPage>
    with SingleTickerProviderStateMixin {
  late TabController? controller;
  late PageController _pageController;
  late CategorieBlog touscategories;
  late List<CategorieBlog> categoriesWithTous;
  List<Actualite> listActualites = [];
  int loadingStatus = 0;
  String keyblog = '';
  Future<void> getActulist(String key_blog) async {
    final Map<String, String> dataMenu = {
      'u_identifiant': widget.userResponse!.token!,
      'cat_identifiant': key_blog,
    };
    ActuResponse listeMenu = await ApiRepository.listActu(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (this.mounted) {
        setState(() {
          listActualites = listeMenu.information!;

          loadingStatus = 1;
        });
      }
    } else {
      if (this.mounted) {
        setState(() {
          loadingStatus = 1;
        });
      }
      print(
        listeMenu.message,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    touscategories =
        CategorieBlog(id: 0, keyCategorie: '', nom: 'Toutes catégories');
    categoriesWithTous = [touscategories, ...widget.categoryblog!];
    controller = TabController(length: categoriesWithTous.length, vsync: this);

    _pageController = PageController(initialPage: 0);
    controller!.addListener(() {
      _pageController.animateToPage(
        controller!.index,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
    launchAllfunction();
  }

  @override
  void dispose() {
    controller?.dispose(); // Assurez-vous de disposer du TabController
    _pageController.dispose(); // Assurez-vous de disposer du TabController
    super.dispose();
  }

  final ConnectivityChecker _connectivity = ConnectivityChecker();
  Future<void> launchAllfunction() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      getActulist(keyblog);
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: categoriesWithTous.length,
      child: Scaffold(
        appBar: AppBar(
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
            "Actualités",
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
          ],
          bottom: TabBar(
            controller: controller,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            onTap: (index) {
              print(categoriesWithTous[index].keyCategorie);
              setState(() {
                keyblog = categoriesWithTous[index].keyCategorie!;
                loadingStatus = 0;
              });
              getActulist(keyblog);
            },
            tabs: categoriesWithTous.map((tab) {
              return Tab(
                text: tab.nom,
              );
            }).toList(),
          ),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              keyblog = categoriesWithTous[index].keyCategorie!;
              loadingStatus = 0;
            });
            getActulist(keyblog);
            controller!.animateTo(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
          children: categoriesWithTous.map((tab) {
            return SingleChildScrollView(
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
                                children: [
                                  SizedBox(height: 50),
                                  CircularProgressIndicator(
                                    backgroundColor: Kprimary,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  Text("Chargement des actualités en cours"),
                                ],
                              ),
                            )
                          : listActu(size, listActualites)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget listActu(Size size, List<Actualite> listActualite) {
    List<Actualite> filteredMenu =
        listActualites.where((uneactu) => uneactu.status == 1).toList();
    return Column(
      children: [
        if (filteredMenu.isEmpty)
          EmptyPage(title: 'Aucune actualités disponible')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredMenu.length,
            itemBuilder: ((context, index) {
              Actualite uneActualite = filteredMenu[index];
              return Container(
                padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                height: 80,
                width: size.width,
                child: InkWell(
                  onTap: () {
                    ClassUtils.navigateTo(
                      context,
                      BlogDetail(
                        actualite: uneActualite,
                        userResponse: widget.userResponse,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Container(
                        height: size.width / 7.5,
                        width: size.width / 7.5,
                        decoration: BoxDecoration(
                          color: Kprimary,
                          // image: DecorationImage(
                          //   image: CachedNetworkImageProvider(uneActualite.image!),
                          // ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Br10(),
                            Expanded(
                              child: Text(
                                uneActualite.titre!,
                                softWrap: true,
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Br5(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.black,
                                  size: 13,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  uneActualite.createdAt!,
                                  style: TextStyle(fontSize: 12, color: kBlack),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }
}
