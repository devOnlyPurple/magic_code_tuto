// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:kondjigbale/views/agenda/meet/call_data.dart';

import '../../../helpers/constants/api_constant.dart';
import '../../../helpers/constants/constant.dart';
import '../../../helpers/manager/api_repository.dart';
import '../../../models/call_data.dart';
import '../../../models/local/default_data.dart';
import '../../../models/local/position_lat_long.dart';
import '../../../models/meet.dart';
import '../../../models/meet_decrypt_response.dart';
import '../../../models/rdv.dart';
import '../../../models/user.dart';
import '../../../providers/user_provider.dart';
import '../../../widget/widget_helpers.dart';

class MeetScreen extends StatefulWidget {
  MeetScreen(
      {super.key,
      required this.unRendevous,
      required this.data,
      required this.devicePosition,
      required this.userResponse});
  Rdv? unRendevous;
  User? userResponse;
  DefaultData? data;
  PositionLatLong? devicePosition;
  @override
  State<MeetScreen> createState() => _MeetScreenState();
}

class _MeetScreenState extends State<MeetScreen> {
  UsersProvider provider = UsersProvider();
  late Meet meetDecrypt = Meet(jwt: '');
  int loadingStatus = 0;
  Future<void> getConsultationInfo(
      String room, String token, String serverUrl, String subject) async {
    try {
      // RdvService().getConsultationEnLigne(widget.rdv).then((value) {
      var callData = CallData.fromMap(CALL_DATA);

      var jitsiMeet = JitsiMeet();
      var options = JitsiMeetConferenceOptions(
        room: room,
        token: token,
        serverURL: serverUrl,
        configOverrides: {
          "startWithAudioMuted": false,
          "startWithVideoMuted": false,
          "subject": subject
        },
        featureFlags: {
          "unsaferoomwarning.enabled": false,
          "ios.screensharing.enabled": true
        },
        // userInfo: JitsiMeetUserInfo(
        //     displayName:
        //         "${provider.userResponse.nom} ${provider.userResponse.prenoms}",
        //     email: provider.userResponse.email),
      );
      jitsiMeet.join(options);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _decryptMeetInfo(String latitude, String longitude) async {
    final Map<String, String> dataMenu = {
      'u_identifiant': widget.userResponse!.token!,
      'r_identifiant': widget.unRendevous!.keyRendezVous!,
      "lang": widget.data!.langue!,
      "latMember": latitude,
      "longMember": longitude,
      "device_id": widget.data!.deviceId!,
      "device_name": widget.data!.deviceName!,
    };
    MeetDecryptResponse decryptResponse =
        await ApiRepository.decryptMeet(dataMenu);
    if (decryptResponse.status == API_SUCCES_STATUS) {
      if (mounted) {
        setState(() {
          meetDecrypt = decryptResponse.information!;
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
        decryptResponse.message,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _decryptMeetInfo(
        widget.devicePosition!.latitude!, widget.devicePosition!.longitude!);
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
            Icons.arrow_back_ios_rounded,
            size: 17,
          ),
        ),
        title: Text('Rendez-vous en ligne'),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(15.0),
              child: loadingStatus == 0
                  ? Center(
                      // Affichez un indicateur de chargement tant que loadingStatus est égal à 0
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Br50(),
                          Br50(),
                          Br50(),
                          Br50(),
                          Br50(),
                          Br30(),
                          CircularProgressIndicator(
                            backgroundColor: Kprimary,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                          Br20(),
                          Text("Cryptage des informations... en cours"),
                        ],
                      ),
                    )
                  : Column(children: [
                      Br50(),
                      Image.asset(
                        "assets/images/security.png",
                        width: size.width,
                        height: 250,
                      ),
                      const Text(
                        "Liaison sécurisée",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Br30(),
                      Text(
                          textAlign: TextAlign.justify,
                          'La connexion avec vote médecin a été sécurisée.Vous démarrer la consultation en toute sécurité.',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: kBlack,
                          )),
                      Br30(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            CustomLoading(context,
                                status: "Démarrage de réunion ");

                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.pop(context);
                              getConsultationInfo(
                                  meetDecrypt.room!,
                                  meetDecrypt.jwt!,
                                  meetDecrypt.serverUrl!,
                                  meetDecrypt.subject!);
                            });
                          },
                          child: Container(
                            height: 45,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Kprimary,
                                borderRadius: BorderRadius.circular(7.5)),
                            child: Align(
                              alignment: Alignment.center,
                              child: Center(
                                child: Text(
                                  "Démarrer maintenant",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]))),
    );
  }
}
