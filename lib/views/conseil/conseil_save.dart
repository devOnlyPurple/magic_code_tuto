import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/conseil.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/widget/empty_page.dart';
import 'package:share_plus/share_plus.dart';

class SaveConseil extends StatefulWidget {
  SaveConseil(
      {super.key, required this.lesSaveConseil, required this.userResponse});
  List<Conseil>? lesSaveConseil;
  User? userResponse;

  @override
  State<SaveConseil> createState() => _SaveConseilState();
}

class _SaveConseilState extends State<SaveConseil> {
  List<Conseil> saveConseils = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  _loadData() async {
    saveConseils = widget.lesSaveConseil!;
    for (Conseil conseil in saveConseils) {
      if (conseil.isLike == 1) {
        conseil.isLiking = true;
      }
      if (conseil.isSave == 1) {
        conseil.isSaving = true;
      }
      print(conseil.toString());
    }
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
        title: const Text(
          "Conseils enregistrés",
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Br20(),
                ConseilList(widget.lesSaveConseil!, size),
              ],
            )),
      ),
    );
  }

  SizedBox ConseilList(List<Conseil> categorieConseil, Size size) {
    late int likeQuantity;

    return SizedBox(
      width: size.width,
      child: Column(
        children: [
          if (categorieConseil.isEmpty)
            EmptyPage(title: 'Aucun.s conseil.s sauvegardé')
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
                        // ClassUtils.navigateTo(
                        //     context,
                        //     ConseilDetails(
                        //       unConseil: uneCategorieConseil,
                        //       userResponse: widget.userResponse,
                        //       onLike: (String keyconseil) {
                        //         _likeDislikeConseil(keyconseil);
                        //       },
                        //       onSave: (String keyconseil) {
                        //         _saveConseil(keyconseil);
                        //       },
                        //       onShare: (String keyconseil) {
                        //         _shareConseil(keyconseil);
                        //       },
                        //     ));
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      child: uneCategorieConseil.typeMedia == 1
                                          ? const Icon(
                                              Icons.image_outlined,
                                              color: Colors.black,
                                            )
                                          : uneCategorieConseil.typeMedia == 2
                                              ? const Icon(
                                                  Icons.videocam_outlined,
                                                  color: Colors.black,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .spatial_audio_off_outlined,
                                                  color: Colors.black,
                                                ),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      uneCategorieConseil.titre!,
                                      softWrap: true,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
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
                                      style: const TextStyle(color: kBlack),
                                    ),
                                  ],
                                ),
                                Br10(),
                                Row(
                                  children: [
                                    const SizedBox(width: 20),
                                    InkWell(
                                      onTap: () async {
                                        try {
                                          // Appel de la méthode Share.share pour partager le lien
                                          await Share.share(
                                              uneCategorieConseil.shareLink!);
                                          // _shareConseil(
                                          //     uneCategorieConseil.keyConseil!);
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
                                            const Icon(
                                              Icons.share_outlined,
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            Text(uneCategorieConseil.shares
                                                .toString())
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
}
