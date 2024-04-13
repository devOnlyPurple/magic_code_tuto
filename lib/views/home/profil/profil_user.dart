// ignore_for_file: prefer_const_constructors, equal_keys_in_map, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/models/groupe_sanguin.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/helpers/utils/sizeconfig.dart';
import 'package:kondjigbale/models/response_login.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/models/ville.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/providers/user_provider.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

import 'package:intl/intl.dart';

class ProfilPage extends StatefulWidget {
  ProfilPage({
    super.key,
    required this.apiPays,
    required this.userResponse,
    required this.groupesangun,
    required this.villeList,
  });
  List<Country>? apiPays;
  List<GroupeSanguin>? groupesangun;
  List<Ville>? villeList;
  User userResponse;
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _telephone = TextEditingController();

  final TextEditingController _nom = TextEditingController();
  final TextEditingController _prenom = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _adresse = TextEditingController();

  final FlutterLocalization localization = FlutterLocalization.instance;
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  var countriess = countries;
  final ClassUtils _classUtils = ClassUtils();
  final storage = FlutterSecureStorage();
  String _selectedGender = '';
  String _selectGroupsanguin = '';
  String _selectVille = '';
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
    _nom.text = widget.userResponse.nom!;
    _prenom.text = widget.userResponse.prenoms!;
    _email.text = widget.userResponse.email!;
    _adresse.text = widget.userResponse.adresse!;
    _date.text = widget.userResponse.dateNaissance!;
    _telephone.text =
        removeFirstSubstring(widget.userResponse.username!, '228');
    _selectedGender = widget.userResponse.sexe!.toString();
    _selectGroupsanguin = widget.userResponse.groupeSanguinKey!;
  }

  Future _select_full_date() async {
    // DateTime eightyearsago = DateTime.now().subtract(Duration(days: 18 * 365));
    DateTime initialDate = DateTime.now();
    DateTime maxDate = DateTime.now();
    DateTime minDate = DateTime.now().subtract(Duration(days: 124 * 365));

    DateTime? picker = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minDate,
      lastDate: maxDate,
    );

    if (picker != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(picker);
      setState(() {
        // _val = formattedDate;
        _date.text = formattedDate;
      });
      // _showTimePicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerListes = Provider.of<ListesProvider>(context);
    // print('=======');
    // // print(providerListes.defaultCountry);
    // print('=======');

    // print(widget.villeList);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: kWhite,
        backgroundColor: kWhite,
        leading: InkWell(
          onTap: () {
            GoRouter.of(context).pop(1);
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
                Br10(),
                Text(
                  'Modifier mon profil',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
                FormMethod(providerListes.sexe, providerListes.groupeSanguins),
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
          // validator: Validatorless.required(VALIDATOR_REQUIRED),
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
            hintText: widget.userResponse.sexe == 1
                ? 'Masculin'
                : widget.userResponse.sexe == 2
                    ? 'Fémnin'
                    : 'Sexe',
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
          )),
    );
  }

  Form FormMethod(List<Sexe> sexList, List<GroupeSanguin> groupList) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Br30(),
            nameFirstname(),
            Br10(),
            numberInput(),
            Br10(),
            emailInput(),
            Br10(),
            sexeSelect(sexList),
            Br10(),
            groupesangunselect(groupList),
            Br10(),
            villeList(),
            Br10(),
            dateSelect(),
            Br10(),
            adresseInput(),
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
              CustomLoading(context, status: "Connexion en cours...");
              _register(pIdentifiant);
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
                "Enregistrer les modifications",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
        'u_identifiant': widget.userResponse.token!,
        'sexe': _selectedGender,
        'adresse': _adresse.value.text,
        'p_identifiant': pIdentifant,
        'phone': numberTotal,
        'adress': _adresse.value.text,
        'email': _email.value.text,
        'gs_identifiant': _selectGroupsanguin,
        'date_naissance': _date.value.text,
        'num_identif_unique': widget.userResponse.numIdentifUnique!,
        'v_identifiant': _selectVille
      };
      LoginResponse responsesignup = await ApiRepository.updateUser(dataSignup);
      Navigator.pop(context);
      print(responsesignup.status);
      if (responsesignup.status == API_SUCCES_STATUS) {
        User userResponse = responsesignup.information!;
        UsersProvider userprovider = UsersProvider();
        print('Maman');
        _classUtils.createLoginSession(userResponse).then((value) {
          userprovider.userInfo = userResponse;
        });
      } else {
        var message = responsesignup.message.toString();
        // UiSnackbar.showSnackbar(context, message, false);
        print(message);
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

  SizedBox groupesangunselect(List<GroupeSanguin> grouplist) {
    return SizedBox(
      child: DropdownButtonFormField<String>(
          // Valeur sélectionnée
          // validator: Validatorless.required(VALIDATOR_REQUIRED),
          items: grouplist.map((GroupeSanguin value) {
            return DropdownMenuItem<String>(
              value: value.keyGroupeSanguin,
              child: Text(value.nom!),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectGroupsanguin = newValue!;
            });
            print(_selectGroupsanguin);
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
            hintText: widget.userResponse.groupeSanguinName!.isNotEmpty
                ? widget.userResponse.groupeSanguinName
                : 'Groupe Sanguin',
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
          )),
    );
  }

  SizedBox villeList() {
    return SizedBox(
      child: DropdownButtonFormField<String>(
          // Valeur sélectionnée
          // validator: Validatorless.required(VALIDATOR_REQUIRED),
          items: widget.villeList!.map((Ville value) {
            return DropdownMenuItem<String>(
              value: value.key,
              child: Text(value.nom!),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectVille = newValue!;
            });
            print(_selectVille);
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
            hintText: widget.userResponse.villeNom!.isNotEmpty
                ? widget.userResponse.villeNom
                : 'Ville',
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
          )),
    );
  }

  SizedBox dateSelect() {
    return SizedBox(
      child: TextFormField(
          keyboardType: TextInputType.none,
          onTap: () {
            _select_full_date();
          },
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          controller: _date,
          // validator: Validatorless.required(VALIDATOR_REQUIRED),
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
            hintText: LocaleData.birthdate.getString(context),
            hintStyle:
                TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
            prefixText: ' ',
          )),
    );
  }

  SizedBox adresseInput() {
    return SizedBox(
      child: TextFormField(
          keyboardType: TextInputType.multiline,
          minLines: 2,
          maxLines: 4,
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          controller: _adresse,
          // validator: Validatorless.required(VALIDATOR_REQUIRED),
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
            hintText: 'Adresse de résidence',
            hintStyle: TextStyle(
              fontSize: 14.0,
              color: Colors.grey.withOpacity(0.5),
            ),
            prefixText: ' ',
          )),
    );
  }

  String removeFirstSubstring(String input, String code) {
    int index = input.indexOf(code);

    if (index != -1) {
      return input.replaceFirst(code, "");
    } else {
      return input;
    }
  }
}
