// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/rdv.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/views/agenda/detail_medecin.dart';

import '../../helpers/constants/api_constant.dart';
import '../../helpers/constants/widget_constants.dart';
import '../../helpers/manager/api_repository.dart';
import '../../helpers/utils/class_utils.dart';
import '../../models/cancel_rdv.dart';
import '../../models/rdv_confirm_response.dart';
import '../../widget/uiSnackbar.dart';
import '../../widget/widget_helpers.dart';
import 'payPage.dart';

class FicheRdv extends StatefulWidget {
  FicheRdv({super.key, required this.unRendevous, required this.userResponse});
  Rdv? unRendevous;
  User? userResponse;
  @override
  State<FicheRdv> createState() => _FicheRdvState();
}

class _FicheRdvState extends State<FicheRdv> {
  int etat = 100;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.unRendevous!.keyRendezVous);
    etat = widget.unRendevous!.etat!;
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
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
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
                child: Text(
                  'Fiche de rendez-vous',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
              ),
              Br20(),
              boxInfoMethod(size),
              Br15(),
              if (etat == 0)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      CustomLoading(context,
                          status: "Confirmation de rendez-vous en cours...");
                      _confirmRdv(widget.unRendevous!.keyRendezVous!);
                    },
                    child: Container(
                      height: 40,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Kprimary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(7.5)),
                      child: Center(
                        child: Text(
                          "Confirmer le rendez-vous",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              if (widget.unRendevous!.etat == RDV_ACCEPTER &&
                  widget.unRendevous!.keyNameConsultation == RDV_LIGNE)
                Column(
                  children: [
                    Br15(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 45,
                          width: size.width,
                          decoration: BoxDecoration(
                              color: Ksecondary,
                              borderRadius: BorderRadius.circular(7.5)),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.videocam_outlined,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Debuter la visio",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Br15(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  w20(),
                  if (etat == 0)
                    Expanded(
                      child: Row(
                        children: [
                          w20(),
                          InkWell(
                            onTap: () {
                              CustomChoixDialog(context,
                                  title: "Déconnexion",
                                  content:
                                      "Vous voulez vraiment annuler ce rendez-vous?",
                                  acceptText: "Oui",
                                  cancelText: "Non", cancelPress: () {
                                Navigator.of(context).pop();
                              }, acceptPress: () {
                                Navigator.of(context).pop();
                                CustomLoading(context,
                                    status:
                                        "Annulation de rendez-vous en cours...");
                                _cancelRdv(widget.unRendevous!.keyRendezVous!);
                              });
                            },
                            child: Text(
                              'Annuler',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Ksecondary,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            CustomChoixDialog(context,
                                title: "Suppresion",
                                content:
                                    "Vous voulez vraiment supprimer ce rendez-vous?",
                                acceptText: "Oui",
                                cancelText: "Non", cancelPress: () {
                              Navigator.of(context).pop();
                            }, acceptPress: () {
                              Navigator.of(context).pop();
                              CustomLoading(context,
                                  status:
                                      "Suppresion de rendez-vous en cours...");
                              _deleteRdv(widget.unRendevous!.keyRendezVous!);
                            });
                          },
                          child: Text(
                            'Supprimer',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: kRed,
                                fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        etat == RDV_ATTENTE
                            ? "En attente de confirmation"
                            : etat == RDV_CONFIRMER
                                ? "Rendez-vous confirmé"
                                : etat == RDV_PAYER
                                    ? "Payé"
                                    : etat == RDV_ACCEPTER
                                        ? " Rendez-vous accepté"
                                        : etat == RDV_REJETER
                                            ? " Rendez-vous rejeté"
                                            : etat == RDV_ANNULER
                                                ? " Rendez-vous rejeté"
                                                : "Passé",
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

  _confirmRdv(String keyRendevous) async {
    final Map<String, String> dataRdv = {
      'u_identifiant': widget.userResponse!.token!,
      'r_identifiant': keyRendevous,
    };

    Confirm_rdv responseConfrimrdv = await ApiRepository.confirmRdv(dataRdv);
    Navigator.pop(context);
    if (responseConfrimrdv.status == API_SUCCES_STATUS) {
      ClassUtils.navigateTo(
          context,
          PayPage(
            payResponse: responseConfrimrdv.information!,
          ));
    } else {
      UiSnackbar.showSnackbar(context, responseConfrimrdv.message!, false);
    }
  }

  _cancelRdv(String keyRendevous) async {
    final Map<String, String> dataRdv = {
      'u_identifiant': widget.userResponse!.token!,
      'r_identifiant': keyRendevous,
    };

    CancelRdv responseConfrimrdv = await ApiRepository.cancelRdv(dataRdv);
    Navigator.pop(context);
    if (responseConfrimrdv.status == API_SUCCES_STATUS) {
      setState(() {
        etat = responseConfrimrdv.information!.etat!;
      });

      UiSnackbar.showSnackbar(context, responseConfrimrdv.message!, true);
    } else {
      UiSnackbar.showSnackbar(context, responseConfrimrdv.message!, false);
    }
  }

  _deleteRdv(String keyRendevous) async {
    final Map<String, String> dataRdv = {
      'u_identifiant': widget.userResponse!.token!,
      'r_identifiant': keyRendevous,
    };

    CancelRdv responseConfrimrdv = await ApiRepository.deletelRdv(dataRdv);
    Navigator.pop(context);
    if (responseConfrimrdv.status == API_SUCCES_STATUS) {
      Navigator.of(context).pop(1);

      UiSnackbar.showSnackbar(context, responseConfrimrdv.message!, false);
    } else {
      UiSnackbar.showSnackbar(context, responseConfrimrdv.message!, false);
    }
  }
}
