// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/sizeconfig.dart';
import 'package:kondjigbale/models/response_login.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:validatorless/validatorless.dart';

class PasswordUpdatePage extends StatefulWidget {
  PasswordUpdatePage({super.key, required this.useresponse});
  User useresponse;
  @override
  State<PasswordUpdatePage> createState() => _PasswordUpdatePageState();
}

class _PasswordUpdatePageState extends State<PasswordUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _newpassword = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  bool passwordShow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 13,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Br10(),
                Center(
                  child: Text(
                    'Modiifer mon mot de passe',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                  ),
                ),
                FormMethod(),
                Br30(),
                ConfirmButtonMethod(widget.useresponse.token!),
              ],
            ),
          ),
        ));
  }

  SizedBox PasswordInputMethod(int fieldstatus) {
    return SizedBox(
      child: TextFormField(
          style: const TextStyle(
              fontWeight: FontWeight.w500, fontSize: 14, color: kBlack),
          obscureText: !passwordShow,
          controller: fieldstatus == 0
              ? _password
              : fieldstatus == 1
                  ? _newpassword
                  : _passwordConfirm,
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
            hintText: fieldstatus == 0
                ? LocaleData.oldPassw.getString(context)
                : fieldstatus == 1
                    ? LocaleData.newPassw.getString(context)
                    : LocaleData.confirmPassw.getString(context),
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

  Form FormMethod() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Br50(),
            PasswordInputMethod(0),
            Br10(),
            PasswordInputMethod(1),
            Br10(),
            PasswordInputMethod(2),
          ],
        ));
  }

  SizedBox ConfirmButtonMethod(String uIdentifiant) {
    return SizedBox(
        width: SizeConfig.screenWidth,
        child: InkWell(
          onTap: () async {
            // await _appSharedPreferences.setUserComplete(true);
            if (_formKey.currentState!.validate()) {
              if (_newpassword.text != _passwordConfirm.text) {
                UiSnackbar.showSnackbar(context, VALIDATOR_CONFIRM, false);
              } else {
                if (_newpassword.text == _password.text) {
                  var messageError =
                      "Le nouveau mot de passe doit être  différent de l'ancien!";
                  UiSnackbar.showSnackbar(context, messageError, false);
                } else {
                  CustomLoading(context, status: "modification en cours...");
                  _changePassw(uIdentifiant);
                }
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
                "Modifier mot de passe",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
          ),
        ));
  }

  _changePassw(String uIdentifiant) async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      Map<String, String> dataPassword = {
        'u_identifiant': uIdentifiant,
        'password': _password.value.text,
        'new_password': _newpassword.value.text,
      };
      LoginResponse responsesignup =
          await ApiRepository.updatepassword(dataPassword);
      Navigator.pop(context);
      print(responsesignup.status);
      if (responsesignup.status == API_SUCCES_STATUS) {
        User userResponse = responsesignup.information!;
        print('Maman');
        _password.clear();
        _newpassword.clear();
        _passwordConfirm.clear();
        var message = responsesignup.message.toString();
        UiSnackbar.showSnackbar(context, message, true);
      } else {
        var message = responsesignup.message.toString();
        UiSnackbar.showSnackbar(context, message, false);
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
}
