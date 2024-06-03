import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:kondjigbale/models/user.dart';

import '../../../helpers/utils/class_utils.dart';
import '../../../models/pharmas.dart';
import '../../../widget/empty_page.dart';
import 'detail_pharmacie.dart';

Widget listpharmaMethode(Size size, List<Pharmas> listePharma, bool isSearching,
    List<Pharmas> filteredList, User userResponse) {
  listePharma = isSearching ? filteredList : listePharma;

  if (listePharma.isEmpty) {
    return Center(
      child: EmptyPage(
        title: 'Aucune pharmacie trouvée',
        asset: 'assets/images/pharma.png',
      ),
    );
  }

  return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listePharma.length,
      itemBuilder: (context, index) {
        Pharmas unePharmacie = listePharma[index];
        return Container(
          padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
          height: 90,
          width: size.width,
          child: InkWell(
            onTap: () {
              ClassUtils.navigateTo(
                  context,
                  PharmacieDetails(
                    unePharmacie: unePharmacie,
                    userResponse: userResponse,
                  ));
            },
            child: Row(
              children: [
                Container(
                  height: size.width / 6.5,
                  width: size.width / 6.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.5),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(unePharmacie.photo!),
                        fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Text(
                        unePharmacie.nom!,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      SizedBox(height: 2),
                      Text(
                        unePharmacie.adresse!,
                        style: TextStyle(fontSize: 11),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${unePharmacie.distance!} km',
                        style: TextStyle(fontSize: 11, color: Colors.black),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}
