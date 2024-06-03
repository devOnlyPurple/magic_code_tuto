
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/helpers/utils/sizeconfig.dart';
import 'package:kondjigbale/models/pays.dart';
import 'package:kondjigbale/models/response_login.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/providers/user_provider.dart';
import 'package:kondjigbale/views/auth/forget_password.dart';
import 'package:kondjigbale/views/auth/register_page.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';
import 'package:get/get.dart';

import '../../classe/device_infos.dart';
import '../../helpers/manager/default_manager.dart';
import '../../helpers/utils/device_all_info.dart';
import '../../models/local/default_data.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.apiPays, required this.listSexe});
  List<Country>? apiPays;
  List<Sexe>? listSexe;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _telephone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _pays = TextEditingController();
  final FlutterLocalization localization = FlutterLocalization.instance;
  final storage = const FlutterSecureStorage();
  var countriess = countries;
  final ClassUtils _classUtils = ClassUtils();
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  final String _selectedGender = '';
  String indicatif = "228";
  String selected_country = "";
  var numberTotal = '';
  bool isSwitched = false;
  bool isnumber = false;
  bool passwordShow = false;

  String paysPrefix = "";
  late String _currentLocale;
  String? locale;
  String? key_lang;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLocale = localization.currentLocale!.languageCode;
    loadDeviceInfo();
    // print(widget.listSexe);
  }

  DeviceAllInfo? deviceAllInfo;
  loadDeviceInfo() async {
    deviceAllInfo = await DeviceAllInfoService().getDeviceLocationAndInfo();

    print(deviceAllInfo!.deviceId);
  }

  @override
  Widget build(BuildContext context) {
    final providerListes = Provider.of<ListesProvider>(context);
    print('=======');
    print(providerListes.sexe);
    print('=======');
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            // Image.asset(
            //   LOGO,
            //   width: Get.width * 0.8,
            // ),
            Br30(),
            // Texte descriptif
            const Text(
              "Bienvenue",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
            ),
            Br50(),

            // Formulaire
            FormMethod(providerListes.pays),
            Br30(),
            ForgetPasswordMethod(),
            Br30(),
            ConfirmButtonMethod(),
            Br30(),
            const Text(
              "Nouveau sur Kondjigbale ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 14),
            ),
            Br10(),
            RegisterScreenMethod()
          ],
        ),
      )),
    ));
  }

  GestureDetector RegisterScreenMethod() {
    return GestureDetector(
      onTap: () {
        ClassUtils.navigateTo(
            context,
            RegisterPage(
              apiPays: widget.apiPays,
            ));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Inscription",
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: Ksecondary),
          )
        ],
      ),
    );
  }

  SizedBox ConfirmButtonMethod() {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: InkWell(
          onTap: () async {
            // await _appSharedPreferences.setUserComplete(true);
            if (_formKey.currentState!.validate()) {
              // Boite de chargement
              CustomLoading(context, status: "Connexion en cours...");
              _login();
            } else {
              print("12");
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 14,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(5)),
            child: const Center(
              child: Text(
                "Connexion",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
          ),
        ));
  }

  GestureDetector ForgetPasswordMethod() {
    return GestureDetector(
      onTap: () {
        ClassUtils.navigateTo(
            context,
            ForgetPassword(
              apiPays: widget.apiPays,
            ));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Mot de passe oublié?",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          )
        ],
      ),
    );
  }

  Form FormMethod(List<Pays> listesPays) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            // Phone input

            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: IntlPhoneField(
                  searchText: "Choisir le pays",
                  languageCode: _currentLocale,
                  onChanged: (value) {
                    if (value.number.isNotEmpty) {
                      setState(() {
                        isnumber = false;
                      });
                    } else {
                      setState(() {
                        isnumber = true;
                      });
                    }
                  },
                  controller: _telephone,
                  onCountryChanged: (value) {
                    setState(() {
                      //selected_country = return_key_pay(value.code, ref.watch(listAllProvider).pays);
                      indicatif = value.dialCode;
                    });
                  },
                  countries: widget.apiPays,
                  // invalidNumberMessage: '',
                  disableLengthCheck: false,
                  flagsButtonMargin: const EdgeInsets.only(left: 15.0),
                  initialCountryCode: 'TG',
                  dropdownIconPosition: IconPosition.trailing,

                  // controller: controller,
                  // obscureText: obscuretext,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    counterText: '',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: kformFieldBackgroundColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: kformFieldBackgroundColor,
                      ),
                    ),
                    fillColor: kformFieldBackgroundColor,
                    filled: true,
                    border: const OutlineInputBorder(
                        // borderSide: new BorderSide(color:Colors.green)
                        ),
                    hintText: 'Téléphone',
                    hintStyle: TextStyle(
                        fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
                    prefixText: ' ',
                  )),
            ),

            Br10(),
            PasswordInputMethod(),
          ],
        ));
  }

  SizedBox PasswordInputMethod() {
    return SizedBox(
      child: TextFormField(
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          obscureText: !passwordShow,
          controller: _password,
          validator: Validatorless.required(VALIDATOR_REQUIRED),
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: kformFieldBackgroundColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: kformFieldBackgroundColor,
              ),
            ),
            fillColor: kformFieldBackgroundColor,
            filled: true,
            border: const OutlineInputBorder(
                // borderSide: new BorderSide(color:Colors.green)
                ),
            hintText: 'Mot de passe',
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
            prefixText: ' ',
            suffixIcon: passwordShow
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        passwordShow = !passwordShow;
                      });
                    },
                    icon: const Icon(Icons.visibility_off,
                        size: 15, color: Colors.grey))
                : IconButton(
                    onPressed: () {
                      setState(() {
                        passwordShow = !passwordShow;
                      });
                    },
                    icon: const Icon(
                      Icons.visibility,
                      size: 15,
                      color: Colors.grey,
                    )),
          )),
    );
  }

  SizedBox TelephoneInputMethod() {
    return SizedBox(
      width: (Get.width - 50) * 0.7,
      child: TextFormField(
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
        controller: _telephone,
        keyboardType: TextInputType.number,
        validator: Validatorless.multiple([
          Validatorless.required(VALIDATOR_REQUIRED),
          if (_pays.value.text == "+228")
            Validatorless.regex(
                RegExp(
                    '^9[0-3][0-9]{6}\$|^70[0-9]{6}\$|^9[6-9][0-9]{6}\$|^79[0-9]{6}\$'),
                "Entrer un numéro valide")
        ]),
        decoration: CustomDecorationMethod(label: "Téléphone"),
      ),
    );
  }

  SizedBox PaysInputMethod(List<Pays> pays) {
    return SizedBox(
      width: (Get.width - 50) * 0.3,
      child: TextFormField(
        readOnly: true,
        controller: _pays,
        //validator: Validatorless.multiple([Validatorless.required("Choisir!")]),
        onTap: () {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(0, Get.height * 0.3, 0, 0),
              items: pays
                  .map<PopupMenuEntry>((e) => PopupMenuItem<String>(
                        value: e.indicatif,
                        onTap: () {
                          setState(() {
                            paysPrefix = e.drapeau!;
                            _pays.text = "+${e.indicatif}";
                          });
                        },
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: e.drapeau!,
                              width: 25,
                              height: 20,
                              placeholder: (context, url) => const CardLoading(
                                height: 20,
                                width: 25,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(e.nomPays!),
                          ],
                        ),
                      ))
                  .toList());
        },
        style: const TextStyle(
            fontWeight: FontWeight.w500, fontSize: 12, color: kBlack),
        decoration: CustomDecorationMethod(
            label: "Pays",
            prefixIconConstraints:
                const BoxConstraints(maxWidth: 50, maxHeight: 40),
            prefixIcon: paysPrefix == ""
                ? null
                : Container(
                    padding: const EdgeInsets.only(left: 10),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: paysPrefix,
                      placeholder: (context, url) => const CardLoading(
                        height: 10,
                        width: 12,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
            labelIsText: false,
            widgetLabel: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pays",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14, color: kBlack),
                ),
                Icon(Icons.expand_more)
              ],
            )),
      ),
    );
  }

  _login() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataLogin = {
        'username': _telephone.value.text,
        'password': _password.value.text,
      };

      LoginResponse responselogin = await ApiRepository.login(dataLogin);
      Navigator.pop(context);
      print(responselogin.status);
      if (responselogin.status == API_SUCCES_STATUS) {
        User userResponse = responselogin.information!;
        UsersProvider userprovider = UsersProvider();
        userprovider.userInfo = userResponse;

        DefaultData data = DefaultData(
          langue: _currentLocale,
          registrationId: '',
          deviceId: deviceAllInfo!.deviceId,
          deviceName: deviceAllInfo!.deviceName,
        );
        DataManager.saveDefaultData(data);
        await storage.write(key: 'connectionStatus', value: 'connected');
        _classUtils.createLoginSession(userResponse).then((value) {
          GoRouter.of(context).go('/home');
        });
        var message = responselogin.message.toString();
        UiSnackbar.showSnackbar(context, message, true);
      } else {
        var message = responselogin.message.toString();
        UiSnackbar.showSnackbar(context, message, false);
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
}
