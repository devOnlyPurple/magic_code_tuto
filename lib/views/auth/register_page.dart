// ignore_for_file: prefer_const_constructors, equal_keys_in_map

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/models/register_response.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/helpers/utils/sizeconfig.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/views/auth/otp_page.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, required this.apiPays});
  List<Country>? apiPays;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _telephone = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _prenom = TextEditingController();
  final TextEditingController _email = TextEditingController();

  final FlutterLocalization localization = FlutterLocalization.instance;
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  var countriess = countries;
  final ClassUtils _classUtils = ClassUtils();
  final storage = FlutterSecureStorage();
  String _selectedGender = '';
  String indicatif = "228";
  String selected_country = "";
  var numberTotal = '';
  bool isChecked = false;
  bool isSwitched = false;
  bool isnumber = false;
  bool passwordShow = false;
  bool isEmailRequired = false;
  String paysPrefix = "";
  late String _currentLocale;
  String? locale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentLocale = localization.currentLocale!.languageCode;
  }

  @override
  Widget build(BuildContext context) {
    final providerListes = Provider.of<ListesProvider>(context);
    print('=======');
    print(providerListes.defaultCountry);
    print('=======');
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: kWhite,
        backgroundColor: kWhite,
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 11,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Br30(),
                Text(
                  LocaleData.inscription.getString(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
                FormMethod(providerListes.sexe),
                Br20(),
                ForgetPasswordMethod(),
                Br30(),
                ConfirmButtonMethod(providerListes.defaultCountry!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container numberInput() {
    return Container(
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
            var tg = '228';
            setState(() {
              indicatif = value.dialCode;
              if (indicatif != tg) {
                isEmailRequired = true;
              } else {
                isEmailRequired = false;
              }
            });
          },
          countries: widget.apiPays,
          // invalidNumberMessage: '',
          disableLengthCheck: false,
          flagsButtonMargin: EdgeInsets.only(left: 15.0),
          initialCountryCode: 'TG',
          dropdownIconPosition: IconPosition.trailing,

          // controller: controller,
          // obscureText: obscuretext,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            counterText: '',
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
            hintText: LocaleData.number.getString(context),
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
            prefixText: ' ',
          )),
    );
  }

  Widget nameFirstname() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            child: TextFormField(
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
                controller: _nom,
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
                  hintText: LocaleData.firstname.getString(context),
                  hintStyle: TextStyle(
                      fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
                  prefixText: ' ',
                )),
          ),
        ),
        w20(),
        Expanded(
          child: SizedBox(
            child: TextFormField(
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
                controller: _prenom,
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
                  hintText: LocaleData.surname.getString(context),
                  hintStyle: TextStyle(
                      fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
                  prefixText: ' ',
                )),
          ),
        ),
      ],
    );
  }

  SizedBox emailInput() {
    return SizedBox(
      child: TextFormField(
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          controller: _email,
          validator: isEmailRequired == true
              ? Validatorless.required(VALIDATOR_REQUIRED)
              : null,
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
            hintText: LocaleData.email.getString(context),
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
            prefixText: ' ',
          )),
    );
  }

  SizedBox sexeSelect(List<Sexe> sexList) {
    return SizedBox(
      child: DropdownButtonFormField<String>(
          // Valeur sélectionnée
          validator: Validatorless.required(VALIDATOR_REQUIRED),
          items: sexList.map((Sexe value) {
            return DropdownMenuItem<String>(
              value: value.key,
              child: Text(value.name!),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
            });
            print(_selectedGender);
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
            hintText: 'Sexe',
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
          )),
    );
  }

  SizedBox PasswordInputMethod(bool isConfirmation) {
    return SizedBox(
      child: TextFormField(
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          obscureText: !passwordShow,
          controller: isConfirmation ? _passwordConfirm : _password,
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
            hintText: isConfirmation == true
                ? LocaleData.password.getString(context)
                : LocaleData.password.getString(context),
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

  Form FormMethod(List<Sexe> sexList) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Br50(),
            nameFirstname(),
            Br10(),
            numberInput(),
            Br10(),
            emailInput(),
            Br10(),
            sexeSelect(sexList),
            Br10(),
            PasswordInputMethod(false),
            Br10(),
            PasswordInputMethod(true),
          ],
        ));
  }

  SizedBox ConfirmButtonMethod(String pIdentifiant) {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: InkWell(
          onTap: () async {
            // await _appSharedPreferences.setUserComplete(true);
            if (_formKey.currentState!.validate()) {
              if (_password.value.text == _passwordConfirm.value.text) {
                CustomLoading(context, status: "Inscription en cours...");
                _register(pIdentifiant);
              } else {
                print('Les mots de passe ne correspondent pas');
              }
            } else {
              print("12");
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 14,
            decoration: BoxDecoration(
                color: Kprimary, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(
                "Je m'inscris",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ),
          ),
        ));
  }

  _register(String pIdentifant) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      numberTotal = indicatif + _telephone.value.text;
      final Map<String, String> dataSignup = {
        'nom': _nom.value.text,
        'prenoms': _prenom.value.text,
        'sexe': _selectedGender,
        'p_identifiant': pIdentifant,
        'phone': numberTotal,
        'password': _password.value.text,
        'email': _email.value.text,
      };
      ResponseSignup responsesignup = await ApiRepository.register(dataSignup);
      Navigator.pop(context);
      print(responsesignup.status);
      if (responsesignup.status == API_SUCCES_STATUS) {
        print('Maman');
        // await storage.write(
        //     key: 'uIdentifiant', value: responsesignup.uIdentifiant);
        ClassUtils.navigateTo(
            context,
            OtpPage(
              uIdentifiant: responsesignup.uIdentifiant,
            ));
        print(responsesignup.resetPass);
      } else {
        var message = responsesignup.message.toString();
        UiSnackbar.showSnackbar(context, message, false);
      }
    } else {
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

  GestureDetector ForgetPasswordMethod() {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "J'accepte les ",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text(
            "Conditions.",
            style: TextStyle(
                fontSize: 14, color: Kprimary, fontWeight: FontWeight.bold),
          ),
          Checkbox(
              value: isChecked,
              activeColor: Kprimary,
              // tristate: true,

              onChanged: (newBool) {
                setState(() {
                  isChecked = newBool!;
                  // isread = !newBool!;
                });
              }),
        ],
      ),
    );
  }
}
