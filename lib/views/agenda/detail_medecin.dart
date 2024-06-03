// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/presta_association.dart';
import 'package:kondjigbale/models/presta_experience.dart';
import 'package:kondjigbale/models/presta_formations.dart';
import 'package:kondjigbale/models/presta_travaux.dart';
import 'package:kondjigbale/models/prestataire.dart';
import 'package:kondjigbale/models/rdv_typeConsulting.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMedecin extends StatefulWidget {
  DetailMedecin({super.key, required this.unPrestataire});
  Prestataire? unPrestataire;
  @override
  State<DetailMedecin> createState() => _DetailMedecinState();
}

class _DetailMedecinState extends State<DetailMedecin> {
  _launchMap(Uri url) async {
    await launchUrl(url);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.unPrestataire!.photo!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Br10(),
              Row(
                children: [
                  Text(
                    "Détails du médecin",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: Kprimary,
                        size: 25,
                      )),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              Br20(),
              prestaPictureMethod(),
              Br20(),
              infoPrestataireMethode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget prestaPictureMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Uri.parse(widget.unPrestataire!.photo!).isAbsolute
              ? CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(widget.unPrestataire!.photo!),
                )
              : CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/images/doctor.png'),
                ),
        ),
        Br10(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ' ${widget.unPrestataire!.prenoms!} ${widget.unPrestataire!.nom!}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Br5(),
            Text('  ${widget.unPrestataire!.expertises!}'),
          ],
        ),
      ],
    );
  }

  Widget infoPrestataireMethode() {
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Row(
            children: [
              Icon(
                Icons.add_location_outlined,
                color: Kprimary,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Adresse",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.unPrestataire!.adresse!,
                    style: TextStyle(color: kBlack),
                  ),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Spacer(),
              Expanded(
                child: InkWell(
                  onTap: () {
                    // _launchMap(Uri.parse(widget.unPrestataire!.localisation!));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: Kprimary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Icon(
                        Icons.map_outlined,
                        color: Kprimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Br10(),
        // expertises
        SizedBox(
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    color: Kprimary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Expertises",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Br10(),
              Expanded(
                  child: Text(
                widget.unPrestataire!.expertises!,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: TextStyle(color: kBlack, fontSize: 13),
              ))
            ],
          ),
        ),

        // types de consultations
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    color: Kprimary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Types de consultations",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Br10(),
              listtypeConsult(widget.unPrestataire!.typeConsultations!)
            ],
          ),
        ),
        Br10(),
        // experiences
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history,
                    color: Kprimary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Experiences",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Br10(),
              listExperiences(widget.unPrestataire!.experiences!)
            ],
          ),
        ),
        Br10(),
        //formations

        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.build_outlined,
                    color: Kprimary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Formations",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Br10(),
              listFormation(widget.unPrestataire!.formations!)
            ],
          ),
        ),
        Br10(),
        //travaux et oublications
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Kprimary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Travaux et publications",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Br10(),
              listTravaux(widget.unPrestataire!.travaux!)
            ],
          ),
        ),

        // langue
        Br10(),
        SizedBox(
          height: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.language_outlined,
                    color: Kprimary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Langues parlées",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Br10(),
              Expanded(
                  child: Text(
                widget.unPrestataire!.denominationLangue!,
                softWrap: true,
                textAlign: TextAlign.justify,
                style: TextStyle(color: kBlack, fontSize: 13),
              ))
            ],
          ),
        ),
        // associations
        Br10(),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people_alt_outlined,
                    color: Kprimary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Associations",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Br10(),
              listAssociations(widget.unPrestataire!.associations!)
            ],
          ),
        ),

        //info legales
        Br10(),
        SizedBox(
          height: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Kprimary,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Informations légales",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Br10(),
              Expanded(
                  child: Row(
                // mainAxisAlignment: MainAxisAlignment.space,
                children: [
                  Text(
                    "N° d'ordre :",
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.unPrestataire!.numeroOrdre.toString(),
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: kBlack, fontSize: 13),
                  ),
                ],
              ))
            ],
          ),
        ),
        Br10(),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                "Fermer",
                style: TextStyle(color: kWhite, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
        Br20(),
      ],
    );
  }

  Widget listExperiences(List<Experiences> experiences) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: experiences.length,
            itemBuilder: ((context, index) {
              Experiences uneExperience = experiences[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0.0 : 8.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        uneExperience.periode!.trim(),
                        style: TextStyle(fontStyle: FontStyle.normal),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                            '${uneExperience.denominationPoste!} - ${uneExperience.formationSanitaire!}',
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style: TextStyle(color: kBlack, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              );
            })),
        Br10(),
      ],
    );
  }

  // formations
  Widget listFormation(List<Formations> formations) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: formations.length,
            itemBuilder: ((context, index) {
              Formations uneFormation = formations[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0.0 : 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      uneFormation.anneeObtention.toString(),
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                          '${uneFormation.denominationDiplome!} - ${uneFormation.denominationEcole!}',
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: kBlack, fontSize: 13)),
                    ),
                  ],
                ),
              );
            })),
        Br10(),
      ],
    );
  }

  //travaux
  Widget listTravaux(List<Travaux> travaux) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: travaux.length,
            itemBuilder: ((context, index) {
              Travaux unTravaux = travaux[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0.0 : 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unTravaux.anneePublication.toString(),
                      style: TextStyle(fontStyle: FontStyle.normal),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          _launchMap(Uri.parse(unTravaux.lienPublication!));
                          print(1);
                        },
                        child: Text(unTravaux.titre!,
                            softWrap: true,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Kprimary.withOpacity(0.5),
                                fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              );
            })),
        Br10(),
      ],
    );
  }

  // type consultation

  Widget listtypeConsult(List<TypeConsultations> typeConsultations) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: typeConsultations.length,
            itemBuilder: ((context, index) {
              TypeConsultations uneConsultation = typeConsultations[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0.0 : 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 70,
                      child: Text(
                        uneConsultation.denominationTypeConsultation!,
                        style: TextStyle(fontStyle: FontStyle.normal),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(uneConsultation.tarif!,
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: kBlack, fontSize: 13)),
                    ),
                  ],
                ),
              );
            })),
        Br10(),
      ],
    );
  }

  // liste associations

  Widget listAssociations(List<Associations> associations) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: associations.length,
            itemBuilder: ((context, index) {
              Associations uneAssociation = associations[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0.0 : 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        uneAssociation.name!,
                        style: TextStyle(fontStyle: FontStyle.normal),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(uneAssociation.poste!,
                          softWrap: true,
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: kBlack, fontSize: 13)),
                    ),
                  ],
                ),
              );
            })),
        Br10(),
      ],
    );
  }
}
