// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/rdv.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/views/agenda/detail_medecin.dart';

class FicheRdv extends StatefulWidget {
  FicheRdv({super.key, required this.unRendevous, required this.userResponse});
  Rdv? unRendevous;
  User? userResponse;
  @override
  State<FicheRdv> createState() => _FicheRdvState();
}

class _FicheRdvState extends State<FicheRdv> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        actions: [
          InkWell(
            onTap: () {},
            child: Icon(Icons.calendar_month),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Br10(),
              Center(
                child: Text(
                  'Fiche de rendez-vous',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
              ),
              Br20(),
              boxInfoMethod(size),
              Br15(),
              InkWell(
                onTap: () {},
                child: Text(
                  'Supprimer',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: kRed, fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget boxInfoMethod(Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 280,
        width: size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Br10(),
            Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DetailMedecin(
                          unPrestataire: widget.unRendevous!.prestataire,
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage:
                        NetworkImage(widget.unRendevous!.prestataire!.photo!),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Br5(),
                    Text(
                      '${widget.unRendevous!.prestataire!.prenoms!} ${widget.unRendevous!.prestataire!.nom!}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Br2(),
                    Text(widget.unRendevous!.prestataire!.expertises!),
                  ],
                ))
              ],
            ),
            Br10(),
            descInfo(Icons.location_pin, 'Lieu',
                widget.unRendevous!.keyNameConsultation!),
            Br5(),
            descInfo(Icons.calendar_month_outlined, 'Date',
                widget.unRendevous!.dateRdv!),
            Br5(),
            descInfo(
              Icons.timer,
              'Horaire',
              widget.unRendevous!.heureDebut!.substring(
                      0, widget.unRendevous!.heureDebut!.length - 2) +
                  ' - ' +
                  widget.unRendevous!.heureFin!
                      .substring(0, widget.unRendevous!.heureFin!.length - 3),
            ),
            Br5(),
            descInfo(Icons.money_sharp, 'Prix', widget.unRendevous!.tarif!),
            Br5(),
            descInfo(Icons.report, 'motif', widget.unRendevous!.motifRdv!),
            Br10(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 40,
                width: size.width,
                decoration: BoxDecoration(
                    color: Kprimary, borderRadius: BorderRadius.circular(7.5)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Passé",
                        style: TextStyle(
                            color: kWhite, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget descInfo(IconData icon, String titre, String info) {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        Icon(
          icon,
          color: Colors.black,
          size: 18,
        ),
        SizedBox(
          width: 3,
        ),
        Column(
          children: [
            Br3(),
            Text(
              '$titre: ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        Column(
          children: [
            Br3(),
            Text(
              info,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        )
      ],
    );
  }
}
