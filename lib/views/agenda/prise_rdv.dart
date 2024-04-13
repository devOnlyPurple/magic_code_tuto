// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/models/crenau_doc_response.dart';
import 'package:kondjigbale/models/creneau.dart';
import 'package:kondjigbale/models/prestataire.dart';
import 'package:kondjigbale/models/rdv_typeConsulting.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:validatorless/validatorless.dart';
import 'package:intl/intl.dart';

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
  int selectedIndex = 0;
  int selectedHours = -1;
  final TextEditingController _motifRdv = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String tc_identifiant = '';
  int loadingStatus = 0;
  List<Creneau> listCreneau = [];
  late TabController? controller;
  late PageController _pageController;
  //  creneau Doctor

  // function to split
  List<String> transformTimeRangeToList(String timeRange) {
    List<String> parts = timeRange.split(" - ");
    if (parts.length != 2) {
      throw ArgumentError("La chaîne doit être au format 'hh:mm - hh:mm'");
    }

    String startTime = parts[0];
    String endTime = parts[1];

    int startHour = int.parse(startTime.split(":")[0]);
    int endHour = int.parse(endTime.split(":")[0]);

    List<String> resultList = [];
    for (int hour = startHour; hour <= endHour; hour++) {
      resultList.add('$hour:00');
    }

    return resultList;
  }

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
            listCreneau = creneau.information!.creneau!;
            controller = TabController(length: listCreneau.length, vsync: this);
            loadingStatus = 1;

            List<String> result = transformTimeRangeToList(
                listCreneau[0].horaire!); // cette liste pour chaque pagevieuw
            _pageController = PageController(initialPage: 0);
            controller!.addListener(() {
              _pageController.animateToPage(
                controller!.index,
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
            print('=====');
            print(result);
            print('=====');
          });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tc_identifiant =
        widget.unPrestataire!.typeConsultations![0].keyTypeConsultation!;
    controller = TabController(length: 0, vsync: this);
    _pageController = PageController(initialPage: 0);
    print(tc_identifiant);
    get_doctor_creneau(tc_identifiant);
  }

  @override
  void dispose() {
    controller?.dispose(); // Assurez-vous de disposer du TabController
    _pageController.dispose(); // Assurez-vous de disposer du TabController
    super.dispose();
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
                  _VerifyStepNext();
                },
                child: Container(
                  height: 45,
                  width: size.width / 4,
                  decoration: BoxDecoration(
                      color: Kprimary, borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Text(
                    LocaleData.onboardbtn2.getString(context),
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
                  selectedIndex = index;
                  tc_identifiant = uneConsultation.keyTypeConsultation!;
                });
                get_doctor_creneau(tc_identifiant);
                print(tc_identifiant);
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
        FormMethod()
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
        Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                controller!.animateTo(index);
                controller!.animateTo(
                  index,
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              },
              children: listCreneau
                  .where((creneau) => creneau.horaire != null)
                  .map((creneau) {
                List<String> result =
                    transformTimeRangeToList(creneau.horaire!);
                return hourCard(result);
              }).toList(),
            ))
      ],
    );
  }

  _VerifyStepNext() {
    if (activeStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          activeStep++;
        });
      }
    }
    if (activeStep == 1) {
      print(1);
    }
  }

  Form FormMethod() {
    return Form(
      key: _formKey,
      child: motifFielMethod(),
    );
  }

  Widget TabDate() {
    return Container(
        height: 50,
        child: TabBar(
          tabAlignment: TabAlignment.start,
          unselectedLabelColor: Colors.grey,
          // labelStyle:
          //     TextStyle(color: Kprimary, fontSize: 15, fontFamily: 'Axiformat'),
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

  Widget hourCard(List<String> hours) {
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
        return GridTile(
            child: InkWell(
          onTap: () {
            setState(() {
              selectedHours = index;
            });
          },
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Ksecondary.withOpacity(0.5)
                  : Kprimary.withOpacity(0.2),
              border: Border.all(color: Colors.grey.shade200), // Bordure grise
              borderRadius: BorderRadius.circular(8), // Bordure arrondie
            ),
            child: Center(
              child: Text(
                hours[index],
                style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? Ksecondary.withOpacity(0.5)
                        : Colors.black),
              ),
            ),
          ),
        ));
      },
    );
  }
}
