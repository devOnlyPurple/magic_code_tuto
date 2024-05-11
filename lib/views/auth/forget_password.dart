import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/helpers/utils/sizeconfig.dart';
import 'package:kondjigbale/models/pays.dart';
import 'package:kondjigbale/models/register_response.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/views/auth/forgetOtp.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';

class ForgetPassword extends StatefulWidget {
  ForgetPassword({super.key, required this.apiPays});
  List<Country>? apiPays;
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final FlutterLocalization localization = FlutterLocalization.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _telephone = TextEditingController();
  late String _currentLocale;
  bool isnumber = false;
  String? locale;
  String indicatif = "228";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLocale = localization.currentLocale!.languageCode;
    // print(widget.listSexe);
  }

  @override
  Widget build(BuildContext context) {
    final providerListes = Provider.of<ListesProvider>(context);
    return Scaffold(
        appBar: AppBar(),
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
                Text(
                  LocaleData.forget.getString(context),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 30),
                ),
                Br50(),

                // Formulaire
                FormMethod(providerListes.pays),
                Br30(),

                ConfirmButtonMethod(),
                Br30(),
              ],
            ),
          )),
        ));
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
                    hintText: LocaleData.number.getString(context),
                    hintStyle: TextStyle(
                        fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
                    prefixText: ' ',
                  )),
            ),

            Br10(),
          ],
        ));
  }

  SizedBox ConfirmButtonMethod() {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: InkWell(
          onTap: () async {
            // await _appSharedPreferences.setUserComplete(true);
            if (_telephone.value.text.isNotEmpty) {
              // Boite de chargement
              CustomLoading(context, status: "Connexion en cours...");
              _verifyAccount();
              // _login();
            } else {
              Fluttertoast.showToast(
                  msg: 'Veuillez renseigner le numéro de téléphone',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.SNACKBAR,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 14,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(5)),
            child: const Center(
              child: Text(
                "Vérifier",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
          ),
        ));
  }

  _verifyAccount() async {
    var numberTotal = indicatif + _telephone.value.text;

    final Map<String, String> dataforget = {
      'phone': numberTotal,
      'type_field': 'sms'
    };
    ResponseSignup responsesignup =
        await ApiRepository.forget_password(dataforget);
    Navigator.pop(context);
    print(responsesignup.status);

    if (responsesignup.status == API_SUCCES_STATUS) {
      print(responsesignup.resetPass);
      ClassUtils.navigateTo(
          context,
          ForgetOtp(
            uIdentifiant: responsesignup.uIdentifiant,
          ));
    } else {
      Fluttertoast.showToast(
          msg: responsesignup.message!,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
