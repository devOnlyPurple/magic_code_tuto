// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/actualite.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_html/flutter_html.dart';

class BlogDetail extends StatefulWidget {
  BlogDetail({super.key, required this.actualite, required this.userResponse});
  Actualite? actualite;
  User? userResponse;
  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(widget.actualite!.description!);
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
                      "Fiche d'actualité",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                    ),
                  ),
                  Br20(),
                  Container(
                    height: 250,
                    width: size.width,
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      color: Kprimary,
                      // image: DecorationImage(
                      //     alignment: Alignment.center,
                      //     image: CachedNetworkImageProvider(
                      //       widget.unePharmacie!.photo!,
                      //     ),
                      //     fit: widget.unePharmacie!.photo!
                      //             .contains('default_pharma.jpg')
                      //         ? BoxFit.fill
                      //         : BoxFit.cover),
                    ),
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
                            widget.actualite!.titre!,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Kprimary),
                          ),
                          Br20(),
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
                                widget.actualite!.createdAt!,
                                style: TextStyle(fontSize: 12, color: kBlack),
                              ),
                              Spacer(),
                              InkWell(
                                  onTap: () {
                                    Share.share(widget.actualite!.shareLink!);
                                  },
                                  child: Icon(Icons.share_outlined)),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                          Br30(),
                          Html(
                            data: widget.actualite!.description!,
                            style: {
                              'html': Style(textAlign: TextAlign.justify),
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ));
  }
}
