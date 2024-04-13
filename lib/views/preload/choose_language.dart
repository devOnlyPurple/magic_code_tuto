// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/views/preload/onboard_page.dart';

class ChooseLanguage extends StatefulWidget {
  ChooseLanguage({super.key, required this.apiPays, required this.listSexe});
  List<Country>? apiPays;
  List<Sexe>? listSexe;
  @override
  State<ChooseLanguage> createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  final storage = FlutterSecureStorage();
  final FlutterLocalization localization = FlutterLocalization.instance;
  List<String> langOption = ['fr', 'en'];
  String _selectlang = '';
  late String _currentLocale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLocale = localization.currentLocale!.languageCode;
    _selectlang = _currentLocale;
    print(widget.apiPays);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: [
          SizedBox(
            height: size.height / 15,
          ),
          Center(
              child: Container(
                  color: kWhite.withOpacity(0.8),
                  width: 280.0,
                  height: 280.0,
                  // Assurez-vous de définir une couleur transparente
                  child: Image.asset('assets/icons/logo_kdg.png'))),
          Center(
              child: Text(
            LocaleData.firsText.getString(context),
            style:
                TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 17),
          )),
          SizedBox(
            height: 40,
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0, bottom: 0.0),
            height: 40,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: DropdownButtonFormField<String>(
                value: _selectlang, // Valeur sélectionnée
                items: langOption.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        if (value == 'fr')
                          Row(
                            children: [
                              Center(
                                child: CountryFlag.fromCountryCode(
                                  'fr',
                                  height: 28,
                                  width: 18,
                                  borderRadius: 8,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Français',
                              ),
                              // Text('data')
                            ],
                          )
                        else
                          Row(
                            children: [
                              Center(
                                child: CountryFlag.fromCountryCode(
                                  'GB',
                                  height: 28,
                                  width: 18,
                                  borderRadius: 8,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'English',
                              ),
                              // Text('data')
                            ],
                          )
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? value) {
                  _setLocal(value!);
                },
                decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.info_outline),
                    // prefixIcon: null,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.fromLTRB(7.0, 0.0, 10.0, 11.0),
                    // labelText: 'Selectionnez le type',
                    hintText: 'Selectionnez le type'),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Spacer(),
          InkWell(
            onTap: () async {
              await storage.write(key: 'connectionStatus', value: 'first');
              ClassUtils.navigateTo(
                  context,
                  OnboardPage(
                    apiPays: widget.apiPays,
                    listSexe: widget.listSexe,
                  ));
            },
            child: Container(
              height: size.height / 15,
              decoration: BoxDecoration(
                  color: Kprimary,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Center(
                child: Text(
                  LocaleData.onboardbtn3.getString(context),
                  style: TextStyle(fontSize: 18, color: kWhite),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
        ]),
      ),
    );
  }

  void _setLocal(String value) async {
    if (value == null) return;

    localization.translate(value);

    await storage.write(key: 'locale', value: value);
    setState(() {
      _currentLocale = value;
    });
    final String? localiser = await storage.read(key: 'locale');
    print(localiser);
  }

  navigateTo(String page, List<Country> listPays) async {
    GoRouter.of(context)
        .pushReplacement('/onboard', extra: {'apiPays': listPays});
  }

  // navigateTo('langue', listPays);
  navigate() async {}
}
