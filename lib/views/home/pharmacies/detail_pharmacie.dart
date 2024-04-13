// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/pharmas.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacieDetails extends StatefulWidget {
  PharmacieDetails(
      {super.key, required this.unePharmacie, required this.userResponse});
  Pharmas? unePharmacie;
  User? userResponse;
  @override
  State<PharmacieDetails> createState() => _PharmacieDetailsState();
}

class _PharmacieDetailsState extends State<PharmacieDetails> {
  // var urldefault =
  //     " https://eu2.contabostorage.com/ab7d17465f7c4b4e9ea50fae12fa229d:dev/pharmacies/default_pharma.jpg";
//telephone
  void _launchURL(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Impossible de lancer $url';
    }
  }

  // link map
  _launchMap(Uri url) async {
    await launchUrl(url);
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
                Br10(),
                Center(
                  child: Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    "Fiche de contact",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                  ),
                ),
                Br20(),
                Container(
                  height: 250,
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      image: DecorationImage(
                          alignment: Alignment.center,
                          image: CachedNetworkImageProvider(
                            widget.unePharmacie!.photo!,
                          ),
                          fit: widget.unePharmacie!.photo!
                                  .contains('default_pharma.jpg')
                              ? BoxFit.fill
                              : BoxFit.cover)),
                ),
                Br20(),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.unePharmacie!.nom!,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Kprimary),
                        ),
                        Br3(),
                        Text(
                          widget.unePharmacie!.adresse!,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Br3(),
                        Text(
                          '${widget.unePharmacie!.distance!} km',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Ksecondary),
                        ),
                        Br30(),
                        Text(
                          "PS: Vous pouvez appeler cette pharmacie pour vérifier la disponibilté des produits.",
                          softWrap: true,
                        ),
                        Br20(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _launchURL(widget.unePharmacie!.contact1!);
                                },
                                child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 15),
                                        SvgPicture.asset(
                                            'assets/icons/appel.svg',
                                            height: 18),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Text(widget.unePharmacie!.contact1!),
                                        Spacer(
                                          flex: 1,
                                        ),
                                        Icon(Icons.chevron_right_outlined),
                                        SizedBox(width: 15),
                                      ],
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  _launchURL(widget.unePharmacie!.contact2!);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 15),
                                      SvgPicture.asset('assets/icons/appel.svg',
                                          height: 18),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Text(widget.unePharmacie!.contact2!),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Icon(Icons.chevron_right_outlined),
                                      SizedBox(width: 15),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Br20(),
                        InkWell(
                          onTap: () {
                            _launchMap(
                                Uri.parse(widget.unePharmacie!.mapLink!));
                          },
                          child: Container(
                            height: 35,
                            width: size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Kprimary.withOpacity(0.3),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.map_outlined,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Voir sur la carte',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Spacer(),
                                Icon(Icons.chevron_right_outlined),
                                SizedBox(width: 15),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
