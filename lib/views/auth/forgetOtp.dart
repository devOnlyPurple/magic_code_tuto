// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/register_response.dart';
import 'package:kondjigbale/models/response_login.dart';
import 'package:kondjigbale/models/user.dart';
import 'package:kondjigbale/providers/user_provider.dart';
import 'package:kondjigbale/views/home/home.dart';
import 'package:kondjigbale/widget/uiSnackbar.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:pinput/pinput.dart';
import 'package:validatorless/validatorless.dart';

class ForgetOtp extends StatefulWidget {
  ForgetOtp({super.key, required this.uIdentifiant});
  String? uIdentifiant;
  @override
  State<ForgetOtp> createState() => _ForgetOtpState();
}

class _ForgetOtpState extends State<ForgetOtp> {
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  final storage = FlutterSecureStorage();
  final ClassUtils _classUtils = ClassUtils();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  String code = '';
  String message = '';
  bool _resend = false;
  final _formKey = GlobalKey<FormState>();
  late Timer _timer;
  int _secondsRemaining = 60;
  bool passwordShow = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    //  final providerListes = Provider.of<ListesProvider>(context);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(fontSize: 22, color: kBlack),
      decoration: BoxDecoration(
        color: kformFieldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Br30(),
                Text(
                  "Changement de mot passe",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
                Br10(),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
                Br30(),
                Pinput(
                  length: 5,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                        // border: Border.all(
                        //     color: Colors.grey.withOpacity(0.5), width: 3),
                        ),
                  ),
                  onCompleted: (pin) {
                    setState(() {
                      code = pin;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                ),
                Br20(),
                FormMethod(),
                Br30(),
                BtnContainer(),
                Br20(),
                InkWell(
                  onTap: _resend == true
                      ? () {
                          CustomLoading(context,
                              status: "Renvoie de code en cours...");
                          _resend_code();
                        }
                      : null,
                  child: Text(
                    "Renvoyer le code ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: _resend == true ? Kprimary : Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                ),
                Br5(),
                Text(_getime()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form FormMethod() {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            PasswordInputMethod(false),
            Br10(),
            PasswordInputMethod(true),
          ],
        ));
  }

  Container BtnContainer() {
    return Container(
        child: InkWell(
      onTap: () {
        _verifyFields(code);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 14,
        decoration: BoxDecoration(
            color: Kprimary, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: Text(
            LocaleData.validate.getString(context),
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ),
    ));
  }

  _sendcodeAndPassword() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    if (isConnect) {
      final Map<String, String> dataConfirm = {
        'u_identifiant': widget.uIdentifiant!,
        'code_validation': code,
        'password': _password.value.text,
      };
      LoginResponse responselogin =
          await ApiRepository.resetPassword(dataConfirm);
      Navigator.pop(context);
      print(responselogin.status);
      if (responselogin.status == API_SUCCES_STATUS) {
        User userResponse = responselogin.information!;
        UsersProvider userprovider = UsersProvider();

        await storage.write(key: 'connectionStatus', value: 'connected');
        _classUtils.createLoginSession(userResponse).then((value) {
          userprovider.userInfo = userResponse;
          ClassUtils.navigateTo(context, Home());
        });
        var message = responselogin.message.toString();
        // UiSnackbar.showSnackbar(context, message, true);
        print(message);
      } else {
        var message = responselogin.message.toString();
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
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

  _verifyFields(String totalCode) {
    if (totalCode.isEmpty || totalCode.length < 5) {
      print(1);
      setState(() {
        message = PIN_CONFIRM;
      });
    } else {
      if (_formKey.currentState!.validate()) {
        if (_password.value.text == _passwordConfirm.value.text) {
          CustomLoading(context, status: "Connexion en cours...");
          _sendcodeAndPassword();
          setState(() {
            message = '';
          });
        } else {
          setState(() {
            message = VALIDATOR_CONFIRM;
          });
        }
      }
    }
  }

  _getime() {
    var text = '00:00';

    if (_resend == true) {
      setState(() {
        text = '';
      });
    } else {
      setState(() {
        text = '   ${LocaleData.dans.getString(context)} 00:$_secondsRemaining';
      });
    }
    return text;
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _resend = true;
          // Ajoutez ici le code à exécuter une fois que le compte à rebours est terminé
        }
      });
    });
  }

  _resend_code() async {
    try {
      bool isConnect = await _connectivity.checkInternetConnectivity();
      if (isConnect) {
        final Map<String, String> dataResend = {
          'u_identifiant': widget.uIdentifiant!,
          'type_field': 'sms',
          'type_validation': 'PASSWORD',
        };
        // AllDialog.showProcess(context);

        // showdialog();
        ResponseSignup responsesignup =
            await ApiRepository.confirmation_resend(dataResend);
        Navigator.pop(context);
        print(responsesignup.status);

        if (responsesignup.status == API_SUCCES_STATUS) {
          setState(() {
            _secondsRemaining = 60;
            _resend = false;
            print(responsesignup.resetPass);
          });
          startTimer();
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
    } catch (e) {
      debugPrint('Erreur lors du renvoie! =>  $e');
    }
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
}
