// ignore_for_file: avoid_print, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/models/rdv.dart';

import 'package:kondjigbale/models/rdv_response.dart';
import 'package:kondjigbale/models/type_consultation.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/views/agenda/doctor_list.dart';
import 'package:kondjigbale/views/agenda/fiche_rdv.dart';
import 'package:kondjigbale/widget/empty_page.dart';
import 'package:provider/provider.dart';

import '../../../helpers/utils/lat_long.dart';
import '../../../models/local/default_data.dart';
import '../../../models/local/position_lat_long.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage(
      {super.key,
      required this.userResponse,
      required this.data,
      required this.devicePosition});
  User? userResponse;
  DefaultData? data;
  PositionLatLong? devicePosition;
  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TypeConsultation> typeConsultations = [];
  List<Rdv> rdvCurrentList = [];
  List<Rdv> rdvPastList = [];
  String keyConsult = '';

  int loadingStatus = 0;
  Future<void> getAppoint(
      String keyConsulting, String latitude, String longitude) async {
    final Map<String, String> dataMenu = {
      'u_identifiant': widget.userResponse!.token!,
      'tc_identifiant': keyConsulting,
      "lang": widget.data!.langue!,
      "latMember": latitude,
      "longMember": longitude,
      "device_id": widget.data!.deviceId!,
      "device_name": widget.data!.deviceName!,
    };
    RdvResponse listeMenu = await ApiRepository.listRdv(dataMenu);
    if (listeMenu.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          rdvCurrentList = listeMenu.information!.current!;
          rdvPastList = listeMenu.information!.past!;
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
    // bool isConnect = await _connectivity.checkInternetConnectivity();
    // if (isConnect) {
    getAppoint(keyConsult, widget.devicePosition!.latitude.toString(),
        widget.devicePosition!.longitude.toString());
    // } else {
    //   print("no connexion");
    //   CustomErrorDialog(
    //     context,
    //     content: "Vérifiez votre connexion internet",
    //     buttonText: "Réessayez",
    //     onPressed: () {
    //       launchAllfunction();
    //       Navigator.of(context).pop();
    //     },
    //   );
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    launchAllfunction();
    loadDeviceInfo();
  }

  PositionLatLong? devicePosition;
  loadDeviceInfo() async {
    devicePosition = await PositionAllInfo().getDevicePosition();
    print(devicePosition!.latitude);
  }

  String _selectedType = '';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final providerListes = Provider.of<ListesProvider>(context);
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
          "Agenda",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Br10(),
            typeConsulting(providerListes.typeConsultations),
            Br10(),
            SizedBox(
              height: 50,
              child: TabBar(
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(
                    color: Colors.black, fontSize: 13, fontFamily: 'Axiformat'),
                indicatorColor: kPrincipalColor,
                controller: _tabController,
                tabs: [
                  Tab(text: 'RDV à venir'),
                  Tab(text: 'RDV passés'),
                ],
              ),
            ),
            Br10(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _buildTabBarViews(
                    size), // Ajoutez les pages d'onglet réelles ici
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingButtonMethod(),
    );
  }

  SizedBox typeConsulting(List<TypeConsultation> typeConsultations) {
    List<TypeConsultation> allTypes = List.from(typeConsultations);
    allTypes.insert(
        0, TypeConsultation(keyTypeConsultation: "", nom: "Tous les types"));
    return SizedBox(
      child: DropdownButtonFormField<String>(
          // Valeur sélectionnée
          // validator: Validatorless.required(VALIDATOR_REQUIRED),
          items: allTypes.map((TypeConsultation value) {
            return DropdownMenuItem<String>(
              value: value.keyTypeConsultation,
              child: Text(value.nom!),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            setState(() {
              _selectedType = newValue!;
              keyConsult = _selectedType;
              loadingStatus = 0;
            });

            await loadDeviceInfo();
            getAppoint(keyConsult, devicePosition!.latitude.toString(),
                devicePosition!.longitude.toString());
            print(keyConsult);
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
            hintText: 'Tous les types',
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
          )),
    );
  }

  // rdvContainer

  Widget listRdvMethod(Size size, List<Rdv> listRdv) {
    return Column(
      children: [
        if (listRdv.isEmpty)
          EmptyPage(title: 'Aucun Rendez-vous disponible')
        else
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: listRdv.length,
              itemBuilder: (context, index) {
                Rdv unRendevous = listRdv[index];

                return InkWell(
                  onTap: () async {
                    final responseRdv = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FicheRdv(
                                  unRendevous: unRendevous,
                                  userResponse: widget.userResponse,
                                  data: widget.data,
                                  devicePosition: devicePosition,
                                )));
                    await loadDeviceInfo();
                    setState(() {
                      if (responseRdv == 1 && mounted) {
                        setState(() {
                          loadingStatus = 0;
                        });

                        getAppoint(
                            keyConsult,
                            devicePosition!.latitude.toString(),
                            devicePosition!.longitude.toString());
                        print(1);
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      height: 90,
                      width: size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundImage:
                                  NetworkImage(unRendevous.prestataire!.photo!),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Br15(),
                                Text(
                                  '${unRendevous.prestataire!.prenoms!} ${unRendevous.prestataire!.nom!}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Br3(),
                                Text(unRendevous.prestataire!.expertises!),
                                Br3(),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_sharp,
                                      size: 11,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Column(
                                      children: [
                                        Br3(),
                                        Text(
                                          unRendevous.dateRdv!
                                              .replaceAll('-', '/'),
                                          style: TextStyle(
                                              color: kBlack, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.timer_outlined,
                                      size: 11,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Column(
                                      children: [
                                        Br3(),
                                        Text(
                                          unRendevous.heureDebut!.substring(
                                                  0,
                                                  unRendevous
                                                          .heureDebut!.length -
                                                      2) +
                                              ' - ' +
                                              unRendevous.heureFin!.substring(
                                                  0,
                                                  unRendevous.heureFin!.length -
                                                      3),
                                          style: TextStyle(
                                              color: kBlack, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
      ],
    );
  }

  // tabview
  List<Widget> _buildTabBarViews(Size size) {
    return [
      SingleChildScrollView(
        child: Column(
          children: [
            Br20(),
            Container(
                // padding: EdgeInsets.all(15.0),
                child: loadingStatus == 0
                    ? Center(
                        // Affichez un indicateur de chargement tant que loadingStatus est égal à 0
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 50),
                            CircularProgressIndicator(
                              backgroundColor: Kprimary,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text("Chargement des rendez-vous  en cours"),
                          ],
                        ),
                      )
                    : listRdvMethod(size, rdvCurrentList)),
          ],
        ),
      ),
      SingleChildScrollView(
        child: Column(
          children: [
            Br20(),
            Container(
                padding: EdgeInsets.all(15.0),
                child: loadingStatus == 0
                    ? Center(
                        // Affichez un indicateur de chargement tant que loadingStatus est égal à 0
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(height: 50),
                            CircularProgressIndicator(
                              backgroundColor: Kprimary,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.grey),
                            ),
                            SizedBox(height: 10),
                            Text("Chargement des rendez-vous  en cours"),
                          ],
                        ),
                      )
                    : listRdvMethod(size, rdvPastList)),
          ],
        ),
      ),
    ];
  }

  Container FloatingButtonMethod() {
    return Container(
      decoration:
          BoxDecoration(color: Kgreen, borderRadius: BorderRadius.circular(12)),
      child: TextButton.icon(
          onPressed: () async {
            final responseAdresse = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DoctorListPage(
                          userResponse: widget.userResponse,
                        )));
            await loadDeviceInfo();
            setState(() {
              if (responseAdresse == 1) {
                getAppoint(keyConsult, devicePosition!.latitude.toString(),
                    devicePosition!.longitude.toString());
                print(1);
              }
            });
          },
          icon: const Icon(
            Icons.calendar_month_outlined,
            color: kWhite,
          ),
          label: const Text(
            "Nouveau rendez-vous ",
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: kWhite),
          )),
    );
  }
}
