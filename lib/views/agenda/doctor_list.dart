// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/doctor_response.dart';
import 'package:kondjigbale/models/langue.dart';
import 'package:kondjigbale/models/prestataire.dart';
import 'package:kondjigbale/models/specialite.dart';
import 'package:kondjigbale/models/type_consultation.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/models/ville.dart';
import 'package:kondjigbale/models/ville_response.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/views/agenda/detail_medecin.dart';
import 'package:kondjigbale/views/agenda/filter_modal.dart';
import 'package:kondjigbale/views/agenda/prise_rdv.dart';
import 'package:kondjigbale/widget/empty_page.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DoctorListPage extends StatefulWidget {
  DoctorListPage({super.key, required this.userResponse});
  User? userResponse;
  @override
  State<DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<DoctorListPage> {
  List<Prestataire> listPresta = [];
  int loadingStatus = 0;
  String keySpecialite = '';
  String keyTypeConsultaltion = '';
  String keySymptome = '';
  String keyLangue = '';
  String keyVille = '';
  String nameDoctor = '';
  Prestataire? doctorChoix;

  int ischoiceDoctor = 0; // 1=
  List<Ville> listville = [];
  /**Doctor list get api  Start*/
  Future<void> getPrestaList(String speKey, String consulKey, String symKey,
      String villeKey, String langKey, String docName) async {
    print(consulKey);
    final Map<String, String> dataMenu = {
      'u_identifiant': widget.userResponse!.token!,
      's_identifiant': speKey,
      'tc_identifiant': consulKey,
      'l_identifiant': langKey,
      'sy_identifiant': symKey,
      'v_identifiant': villeKey,
      'name': docName,
    };
    DoctorResponse listeMenu = await ApiRepository.listDoctor(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          listPresta = listeMenu.information!;
          loadingStatus = 1;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          loadingStatus = 1;
        });
      }
      print(
        listeMenu.message,
      );
    }
  }

  final ConnectivityChecker _connectivity = ConnectivityChecker();
  Future<void> launchAllfunction() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      getPrestaList(keySpecialite, keyTypeConsultaltion, keySymptome, keyVille,
          keyLangue, nameDoctor);
      getVilleList();
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
  /**Doctor list get api End */

  Future<void> getVilleList() async {
    final Map<String, String> dataMenu = {
      'p_identifiant': widget.userResponse!.paysKey!,
    };
    VilleResponse listeMenu = await ApiRepository.listVille(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          listville = listeMenu.information!;
          loadingStatus = 1;
        });
      }
    } else {
      if (mounted) {
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
    // TODO: implement initState
    super.initState();
    launchAllfunction();
  }

  void showAlert(
      BuildContext context,
      List<Langue>? langues,
      List<Specialite>? specialites,
      List<TypeConsultation>? typeConsultations) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FilterModal(
          villeList: listville,
          langues: langues,
          specialites: specialites,
          typeConsultations: typeConsultations,
          consKey: keyTypeConsultaltion,
          langKey: keyLangue,
          speKey: keySpecialite,
          villeKey: keyVille,
          docName: nameDoctor,
          onLoadList: (speKey, consulKey, symKey, villeKey, langKey, docName) {
            getPrestaList(
                speKey, consulKey, symKey, villeKey, langKey, docName);
          },
        );
      },
    ).then((value) {
      setState(() {
        if (value == 1) {
          loadingStatus = 0;
        } else {}
      });
      // filterData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerListes = Provider.of<ListesProvider>(context);
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
        title: const Text(
          "Liste des docteurs",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              Br10(),
              searchAndFilter(providerListes.langues,
                  providerListes.specialites, providerListes.typeConsultations),
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
                      Text("Chargement des prestataires en cours"),
                    ],
                  ),
                )
              else if (listPresta.isNotEmpty)
                Column(
                  children: [
                    if (ischoiceDoctor != 0)
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              ' $SELECT_DOCTOR',
                              style: TextStyle(color: kRed, fontSize: 15),
                            ),
                          ),
                          Br10(),
                        ],
                      ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3,
                              color: ischoiceDoctor != 0
                                  ? kRed
                                  : Colors.transparent),
                          borderRadius: BorderRadius.circular(15)),
                      child: Column(
                        children: [
                          Br10(),
                          if (listPresta.isEmpty)
                            EmptyPage(title: 'Aucun médecin trouvé')
                          else
                            MasonryGridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listPresta.length,
                                gridDelegate:
                                    SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: ((context, index) {
                                  Prestataire unDocteur = listPresta[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: doctorMethod(unDocteur, size),
                                  );
                                })),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //     color: kWhite,
      //     elevation: 0,
      //     surfaceTintColor: kWhite,
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //       crossAxisAlignment: CrossAxisAlignment.end,
      //       children: [
      //         Spacer(),
      //         InkWell(
      //           onTap: () {
      //             setState(() {
      //               if (doctorChoix == null) {
      //                 ischoiceDoctor = 1;
      //               } else {
      //                 ischoiceDoctor = 0;

      //                 ClassUtils.navigateTo(
      //                     context,
      //                     AppointmentPage(
      //                       unPrestataire: doctorChoix,
      //                       userResponse: widget.userResponse,
      //                     ));
      //               }
      //             });
      //           },
      //           child: Container(
      //             height: 45,
      //             width: size.width / 4,
      //             decoration: BoxDecoration(
      //                 color: Kprimary, borderRadius: BorderRadius.circular(15)),
      //             child: Center(
      //                 child: Text(
      //               LocaleData.onboardbtn2.getString(context),
      //               style: TextStyle(
      //                   fontWeight: FontWeight.bold,
      //                   color: kWhite,
      //                   fontSize: 15),
      //             )),
      //           ),
      //         ),
      //       ],
      //     )),
    );
  }

  Widget searchAndFilter(List<Langue>? langues, List<Specialite>? specialites,
      List<TypeConsultation>? typeConsultations) {
    return SizedBox(
      width: double.infinity, // Définir une largeur maximale
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: kBlack,
                  ),
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
                    border: OutlineInputBorder(),
                    hintText: 'Rechercher un médecin',
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    prefixText: ' ',
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 55,
                width: 70,
                decoration: BoxDecoration(
                    color: Ksecondary.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15)),
                child: InkWell(
                  onTap: () {
                    showAlert(context, langues, specialites, typeConsultations);
                  },
                  child: Center(
                    child: Icon(
                      Icons.filter_list_sharp,
                      color: kWhite,
                      size: 33,
                    ),
                  ),
                ),
              )
            ],
          ),
          Br10(),
        ],
      ),
    );
  }

  Widget doctorMethod(Prestataire doctor, Size size) {
    return GestureDetector(
      onTap: () {
        setState(() {
          doctorChoix = doctor;
          ischoiceDoctor = 0;
        });
        ClassUtils.navigateTo(
            context,
            AppointmentPage(
              unPrestataire: doctorChoix,
              userResponse: widget.userResponse,
            ));
      },
      child: Container(
        width: (size.width - 40) / 2,
        decoration: BoxDecoration(
            color: Kprimary.withOpacity(doctor == doctorChoix ? 0.3 : 0),
            borderRadius: BorderRadius.circular(16)),
        child: Card(
          elevation: 0.0,
          color: Colors.grey.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Br5(),
              SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Uri.parse(doctor.photo!).isAbsolute
                        ? CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(doctor.photo!),
                          )
                        : CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/doctor.png'),
                          )),
              ),
              Br10(),
              Text(
                doctor.prenoms!,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14, color: kBlack),
              ),
              Br5(),
              Text(
                doctor.denominationSpecialite!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, fontSize: 12, color: kBlack),
              ),
              Br5(),
              Container(
                width: size.width / 7.5,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(18)),
                child: Center(
                  child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return DetailMedecin(
                              unPrestataire: doctor,
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.info_outline_rounded)),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
