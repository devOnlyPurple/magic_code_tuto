// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/add_rdv_response.dart';
import 'package:kondjigbale/models/adresseData/adresse_data.dart';
import 'package:kondjigbale/models/adresse_response.dart';
import 'package:kondjigbale/models/crenau_doc_response.dart';
import 'package:kondjigbale/models/creneau.dart';
import 'package:kondjigbale/models/prestataire.dart';
import 'package:kondjigbale/models/rdv.dart';
import 'package:kondjigbale/models/rdv_confirm_response.dart';
import 'package:kondjigbale/models/rdv_response.dart';
import 'package:kondjigbale/models/rdv_typeConsulting.dart';
import 'package:kondjigbale/models/rendevous.dart';
import 'package:kondjigbale/models/une_adresse.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/views/adresse/new_adresse.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:validatorless/validatorless.dart';
import 'package:intl/intl.dart';

import 'payPage.dart';

class AppointmentPage extends StatefulWidget {
  AppointmentPage(
      {super.key, required this.unPrestataire, required this.userResponse});
  Prestataire? unPrestataire;
  User? userResponse;
  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with TickerProviderStateMixin {
  int activeStep = 0;
  int selectedIndex = -1;
  int selectedHours = -1;
  final TextEditingController _motifRdv = TextEditingController();
  final FocusNode _motfiNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String tc_identifiant = '';
  int dureConsultation = 0;
  int loadingStatus = 0;
  List<Creneau> listCreneau = [];
  late TabController? controller;
  late PageController _pageController;
  List<int> pageAndSelctedIndex = [0, -1];
  bool isDomicileSelect = false;
  String adresseSelect = 'Adresse';
  String adresseKey = '';
  String latitude = '';
  String longitude = '';
  int PageIndex = 0;
  TypeConsultations consult = TypeConsultations();
  //  creneau Doctor
  String heureRdv = '';
  String nameTypeConsult = '';
  String dateSelect = "";
  String dateSelectNoFormat = "";
  String amount = '';
  //end
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  Future<void> get_doctor_creneau(String tcIdentifiant) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataMenu = {
        'u_identifiant': widget.userResponse!.token!,
        'tc_identifiant': tcIdentifiant,
        'd_identifiant': widget.unPrestataire!.token!,
      };

      NicheDoctorResponse creneau = await ApiRepository.creneauDoctor(dataMenu);
      if (creneau.status == API_SUCCES_STATUS) {
        if (this.mounted) {
          setState(() {
            amount = creneau.information!.amount!;
            listCreneau = creneau.information!.creneau!;
            controller = TabController(length: listCreneau.length, vsync: this);
            loadingStatus = 1;
            dureConsultation = creneau.information!.dureeConsultation!;
            // cette liste pour chaque pagevieuw
            _pageController = PageController(initialPage: 0);
            controller!.addListener(() {
              _pageController.animateToPage(
                controller!.index,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
            dateSelect = formatDateStringyear(
              listCreneau[0].date!,
            );
            dateSelectNoFormat = listCreneau[0].date!;
          });
          print(dateSelectNoFormat);
        }
      } else {
        if (this.mounted) {
          setState(() {
            loadingStatus = 1;
          });
        }
        print(
          creneau.message,
        );
      }
    } else {
      CustomErrorDialog(
        context,
        content: "Vérifiez votre connexion internet",
        buttonText: "Réessayez",
        onPressed: () {
          get_doctor_creneau(tcIdentifiant);
          Navigator.of(context).pop();
        },
      );
    }
  }

// Output: [11, 12, 13, 14, 15, 16, 17, 18]
  List<String> genererHeures(String plageHoraire, int dureeEnMinutes) {
    List<String> heuresObtenues = [];

    // Divise la plage horaire en heures de début et de fin
    List<String> heures = plageHoraire.split(' - ');

    if (heures.length == 2) {
      DateTime debut = DateFormat('HH:mm').parse(heures[0]);
      DateTime fin = DateFormat('HH:mm').parse(heures[1]);

      while (debut.isBefore(fin)) {
        heuresObtenues.add(DateFormat('HH:mm').format(debut));
        debut = debut.add(Duration(minutes: dureeEnMinutes));
      }
      heuresObtenues.add(DateFormat('HH:mm').format(fin));
    } else {
      throw Exception("Format de plage horaire invalide.");
    }

    return heuresObtenues;
  }

  @override
  void dispose() {
    controller?.dispose(); // Assurez-vous de disposer du TabController
    _pageController.dispose();
    _motfiNode.dispose(); // Assurez-vous de disposer du TabController
    super.dispose();
  }

  List<Adresse> lesAdresses = [];
  Future<void> getAdresse() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();

    if (isConnect) {
      final Map<String, String> dataAdresse = {
        'u_identifiant': widget.userResponse!.token!,
      };
      AdresseResponse listeAdresse =
          await ApiRepository.listAdresse(dataAdresse);
      if (listeAdresse.status == API_SUCCES_STATUS) {
        if (mounted) {
          setState(() {
            lesAdresses = listeAdresse.information!;
          });
        }
      } else {
        print(
          listeAdresse.message,
        );
      }
    } else {
      CustomErrorDialog(
        context,
        content: "Vérifiez votre connexion internet",
        buttonText: "Réessayez",
        onPressed: () {
          getAdresse();
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = TabController(length: 0, vsync: this);
    _pageController = PageController(initialPage: 0);
    getAdresse();
  }

  @override
  Widget build(BuildContext context) {
    Prestataire unDoc = widget.unPrestataire!;
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
        title: Text(
          unDoc.prenoms!,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Br10(),
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      height: 4,
                      thickness: 3,
                      color: kPrincipalColor,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Divider(
                      height: 4,
                      thickness: 3,
                      color: activeStep > 0 ? kPrincipalColor : Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Divider(
                      height: 4,
                      thickness: 3,
                      color: activeStep > 1 ? kPrincipalColor : Colors.grey,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
            Br20(),
            if (activeStep == 0) buildFirstStep(unDoc.typeConsultations!, size),
            if (activeStep == 1)
              buildSecondStep(unDoc.typeConsultations!, size),
            if (activeStep == 2) buildThirdStep(size),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: kWhite,
          elevation: 0,
          surfaceTintColor: kWhite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  if (activeStep == 0) {
                    Navigator.of(context).pop();
                  } else {
                    setState(() {
                      activeStep--;
                    });
                    print(activeStep);
                  }
                },
                child: Container(
                  height: 45,
                  width: size.width / 4,
                  decoration: BoxDecoration(
                      color: Kprimary, borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Text(
                    LocaleData.precedent.getString(context),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                        fontSize: 15),
                  )),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  if (activeStep < 2) {
                    _VerifyStepNext();
                  } else {
                    CustomLoading(context,
                        status: "Ajout de rendez-vous en cours...");
                    _addRdv();
                  }
                },
                child: Container(
                  height: 45,
                  width: size.width / 4,
                  decoration: BoxDecoration(
                      color: Kprimary, borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Text(
                    activeStep < 2
                        ? LocaleData.onboardbtn2.getString(context)
                        : 'Soumettre',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kWhite,
                        fontSize: 15),
                  )),
                ),
              ),
            ],
          )),
    );
  }

  Widget listtypeConsult(List<TypeConsultations> typeConsultations, Size size) {
    return Container(
      // crossAxisAlignment: CrossAxisAlignment.start,
      height: 100,
      width: size.width,
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: typeConsultations.length,
          itemBuilder: (context, index) {
            TypeConsultations uneConsultation = typeConsultations[index];
            bool isSelected = index == selectedIndex;
            return InkWell(
              onTap: () {
                setState(() {
                  loadingStatus = 0;
                  consult = uneConsultation;
                  selectedIndex = index;
                  tc_identifiant = uneConsultation.keyTypeConsultation!;

                  if (consult.keyTypeConsultation == CONSEIL_KEY) {
                    isDomicileSelect = true;
                  } else {
                    isDomicileSelect = false;
                    _motfiNode.requestFocus();
                  }
                });
              },
              child: Container(
                height: 130,
                width: 90.0, // Largeur fixe pour chaque élément de la liste
                margin: EdgeInsets.only(right: 6.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Kprimary.withOpacity(0.5)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        uneConsultation.denominationTypeConsultation!,
                        style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? kWhite : kBlack),
                      ),
                      Br3(),
                      Text(
                        uneConsultation.tarif!,
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget motifFielMethod() {
    return SizedBox(
      child: TextFormField(
          focusNode: _motfiNode,
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 10,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          controller: _motifRdv,
          validator: Validatorless.required(VALIDATOR_REQUIRED),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: kformFieldBackgroundColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: kformFieldBackgroundColor,
              ),
            ),
            fillColor: kformFieldBackgroundColor,
            filled: true,
            border: OutlineInputBorder(
                // borderSide: new BorderSide(color:Colors.green)
                ),
            hintText: 'Motif de prise de rendez-vous',
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: Colors.grey.withOpacity(0.5),
            ),
            prefixText: ' ',
          )),
    );
  }

  Widget buildFirstStep(List<TypeConsultations> typeConsultations, Size size) {
    return Column(
      children: [
        Center(
          child: Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Type de consultation",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
        ),
        Br20(),
        listtypeConsult(typeConsultations, size),
        Br20(),
        FormMethod(size)
      ],
    );
  }

  // honoraire

  Widget buildSecondStep(List<TypeConsultations> typeConsultations, Size size) {
    return Column(
      children: [
        Center(
          child: Text(
            // ignore: prefer_interpolation_to_compose_strings
            "Horaire",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
          ),
        ),
        Br10(),
        TabDate(),
        Br10(),
        if (loadingStatus == 0)
          Center(
            // Affichez un indicateur de chargement tant que loadingStatus est égal à 0
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 50),
                CircularProgressIndicator(
                  backgroundColor: Kprimary,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
                SizedBox(height: 10),
                Text("Chargement des créneaux du docteur  en cours"),
              ],
            ),
          )
        else
          Container(
              height: MediaQuery.of(context).size.height * 1,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    dateSelect = formatDateStringyear(
                      listCreneau[index].date!,
                    );
                    dateSelectNoFormat = listCreneau[index].date!;
                    PageIndex = index;
                    if (pageAndSelctedIndex[0] == index) {
                      selectedHours = pageAndSelctedIndex[1];
                    } else {
                      selectedHours = -1;
                    }
                  });
                  print(dateSelectNoFormat);
                  controller!.animateTo(index);
                  controller!.animateTo(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                },
                children: listCreneau
                    .where((creneau) =>
                        creneau.horaire != null ||
                        (creneau.reserved != null &&
                            creneau.reserved!.isNotEmpty))
                    .map((creneau) {
                  List<String> result =
                      genererHeures(creneau.horaire!, dureConsultation);

                  List<String> reservedHours = creneau.reserved ?? [];
                  return hourCard(result, reservedHours);
                }).toList(),
              ))
      ],
    );
  }

  _VerifyStepNext() {
    print(activeStep);
    if (activeStep == 0) {
      if (selectedIndex == -1) {
        UiSnackbar.showSnackbar(
            context, "Veuillez sélectionnez un type de consultation. ", false);
      } else if (_formKey.currentState!.validate()) {
        setState(() {
          activeStep = 1;
        });
        get_doctor_creneau(tc_identifiant);
      }
    } else if (activeStep == 1) {
      if (selectedHours != -1) {
        setState(() {
          activeStep++;
        });
      }
    }
  }

  // Form FormMethod() {
  //   return Form(
  //     key: _formKey,
  //     child: motifFielMethod(),
  //   );
  // }
  Form FormMethod(Size size) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            if (isDomicileSelect == true)
              Column(children: [
                adresseList(),
                Br10(),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      final responseAdresse = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => AdresseNewPage(
                                    uIdentifiant: widget.userResponse!.token!,
                                  )));
                      setState(() {
                        if (responseAdresse != 0) {
                          adresseData adresse = responseAdresse as adresseData;
                          getAdresse();
                          latitude = adresse.lat;
                          longitude = adresse.long;
                          adresseSelect = adresse.adresseName;
                          _motfiNode.requestFocus();

                          // print(latitude);
                        }
                      });
                    },
                    child: Container(
                      height: 45,
                      width: size.width / 3,
                      decoration: BoxDecoration(
                          color: Kprimary,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Text(
                        LocaleData.newAdress.getString(context),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kWhite,
                            fontSize: 15),
                      )),
                    ),
                  ),
                ),
                Br10(),
              ]),
            motifFielMethod(),
          ],
        ));
  }

  Widget TabDate() {
    return Container(
        height: 50,
        child: TabBar(
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Kprimary,
          isScrollable: true,
          controller: controller,
          tabs: listCreneau.map((tab) {
            return Tab(
              child: Column(
                children: [
                  Text(
                    tab.jourName!,
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  Br3(),
                  Text(
                      formatDateString(
                        tab.date!,
                      ),
                      style: TextStyle(fontSize: 12)),
                  Br2(),
                ],
              ),
            );
          }).toList(),
        ));
  }

  String formatDateString(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMM', 'fr_FR').format(date);
    return formattedDate;
  }

  String formatDateStringyear(String dateString) {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMM yyyy', 'fr_FR').format(date);
    return formattedDate;
  }

  Widget hourCard(List<String> hours, List<String> reservedHours) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 3, // Espacement vertical entre les éléments

        childAspectRatio: 1.7, // Taille réactive
      ),
      itemCount: hours.length,
      itemBuilder: (context, index) {
        bool isSelected = index == selectedHours;
        bool isReserved = reservedHours.contains(hours[index]);
        return GridTile(
            child: InkWell(
          onTap: !isReserved
              ? () {
                  setState(() {
                    selectedHours = index;
                    heureRdv = hours[index];
                    pageAndSelctedIndex = [PageIndex, selectedHours];
                  });
                  // print(heureRdv);
                }
              : null,
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Ksecondary.withOpacity(0.7)
                  : isReserved
                      ? Colors.grey.shade200 // Griser si réservé
                      : Kprimary.withOpacity(0.2),
              border: Border.all(color: Colors.grey.shade200), // Bordure grise
              borderRadius: BorderRadius.circular(8), // Bordure arrondie
            ),
            child: Center(
              child: Text(
                hours[index],
                style: TextStyle(
                    fontSize: 14, color: isSelected ? kWhite : Colors.black),
              ),
            ),
          ),
        ));
      },
    );
  }

  Widget buildThirdStep(Size size) {
    Prestataire unDoc = widget.unPrestataire!;
    return Column(children: [
      Center(
        child: Text(
          // ignore: prefer_interpolation_to_compose_strings
          "Récapitulatif",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
        ),
      ),
      Br10(),
      Container(
        height: 250,
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.12),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Br20(),
            Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Center(
                  child: Uri.parse(widget.unPrestataire!.photo!).isAbsolute
                      ? CircleAvatar(
                          radius: 35,
                          backgroundImage:
                              NetworkImage(widget.unPrestataire!.photo!),
                        )
                      : CircleAvatar(
                          radius: 35,
                          backgroundImage:
                              AssetImage('assets/images/doctor.png'),
                        ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${unDoc.prenoms!} ${unDoc.nom!}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Br2(),
                      Text(
                        unDoc.denominationSpecialite!,
                        softWrap: true,
                      )
                    ],
                  ),
                )
              ],
            ),
            Br15(),
            recapListMethod(
                title: "Type de consultation:",
                value: consult.denominationTypeConsultation),
            recapListMethod(
                title: "Prix de consultation:", value: consult.tarif),
            recapListMethod(title: "Motif:", value: _motifRdv.text),
            recapListMethod(title: "Date:", value: dateSelect),
            recapListMethod(title: "Heure de début:", value: heureRdv),
          ],
        ),
      ),
      Br20(),
      Text(
          textAlign: TextAlign.justify,
          "NB : Un paiement de $amount non rembourable est requis pour confirmer votre prise de rendez-vous. Vous serez rédirigé vers une page de paiement pour éffectuer votre transaction",
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: kRed,
              fontStyle: FontStyle.italic)),
    ]);
  }

  SizedBox adresseList() {
    return SizedBox(
      child: DropdownButtonFormField<String>(
          // Valeur sélectionnée
          validator: (value) {
            // Condition pour appliquer la validation requise uniquement si adresseSelect est égal à 'Adresse'
            if (adresseSelect == 'Adresse' && value == null) {
              return VALIDATOR_REQUIRED; // Message d'erreur si la valeur est requise
            }
            return null; // Retourne null pour indiquer que la validation a réussi
          },
          items: lesAdresses.map((Adresse value) {
            return DropdownMenuItem<String>(
              value: value.keyAdresse,
              child: Text(value.nomAdresse!),
            );
          }).toList(),
          onChanged: (String? newValue) {
            print(adresseSelect);
            Adresse selectedAdresse = lesAdresses
                .firstWhere((adresse) => adresse.keyAdresse == newValue);

            _motfiNode.requestFocus();
            setState(() {
              adresseSelect = selectedAdresse.nomAdresse!;
              adresseKey = newValue!;
              latitude = selectedAdresse.latitude!;
              longitude = selectedAdresse.longitude!;
            });
          },
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: kformFieldBackgroundColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: kformFieldBackgroundColor,
              ),
            ),
            fillColor: kformFieldBackgroundColor,
            filled: true,
            border: OutlineInputBorder(
                // borderSide: new BorderSide(color:Colors.green)
                ),
            hintText: adresseSelect,
            hintStyle: TextStyle(fontSize: 14.0, color: Colors.black45),
          )),
    );
  }

  Widget recapListMethod({String? title, String? value}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, left: 8),
      child: Row(
        children: [
          Text(
            title!,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16, color: Kprimary),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            value!,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // add rdv
  _addRdv() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      var adressLatLoong = '$latitude,$longitude';
      final Map<String, String> dataRdv = {
        'u_identifiant': widget.userResponse!.token!,
        'd_identifiant': widget.unPrestataire!.token!,
        'tc_identifiant': consult.keyTypeConsultation!,
        'motif': _motifRdv.value.text,
        'adresse': adressLatLoong,
        'date': dateSelectNoFormat,
        'time': heureRdv,
      };

      Add_rdv responseRdv = await ApiRepository.addRdv(dataRdv);
      Navigator.pop(context);
      if (responseRdv.status == API_SUCCES_STATUS) {
        Rdv rendevous = responseRdv.rendezVous!;
        String rendevousKey = rendevous.keyRendezVous!;
        _confirmRdv(rendevousKey);
      } else {
        UiSnackbar.showSnackbar(context, responseRdv.message!, false);
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

  // confirmRdv

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
}
