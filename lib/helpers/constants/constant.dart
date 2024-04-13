import 'package:flutter/material.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';

Size calculateScreenSize(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return Size(screenWidth, screenHeight);
}

// bannière principale
const kPrincipalColor = Color(0XFF009428);
const kSecondColor = Color(0XFFff9f00);
const Color Kprimary = Color.fromRGBO(8, 132, 37, 1);
const Color Ksecondary = Color.fromRGBO(255, 159, 0, 1);
const Color Kbackground = Color.fromRGBO(253, 254, 253, 1);
const Color Ksplash = Color.fromRGBO(0, 148, 40, 1);
const Color kWhite = Color(0xffffffff);
const Color kRose = Color.fromRGBO(255, 243, 236, 1);
const Color kformFieldBackgroundColor = Color.fromRGBO(242, 245, 249, 1);
const Color kGrey = Color(0xffD7D7D7);
const Color kGreyB7 = Color(0xffB7B7B7);
const Color kGrey8E = Color(0xff8E8E8E);
const Color kGrey83 = Color(0xff838383);
const Color kGrey85 = Color(0xff858585);

const Color Kgreen = Color.fromRGBO(10, 94, 33, 1);
const Color Kgreen83 = Color.fromRGBO(210, 226, 214, 1);

const Color kBlue = Color(0xff0A8ED9);
const Color kRed = Color.fromARGB(255, 217, 10, 10);
const Color kOrange = Colors.orange;
const Color kLightBlue = Color.fromRGBO(220, 240, 225, 1);

// bannière principale

const kBlack = Colors.black45;
const kEndcolor = Color(0XFF462e01);
final primaryColor = ClassUtils.colorFromHex("2C9D1B"); //for logo foncé
final secondaryColor = ClassUtils.colorFromHex("455A64");
final thirdColor = ClassUtils.colorFromHex("1F6E13");
final fourthColor = ClassUtils.colorFromHex("c2c2cb");
final textColor = ClassUtils.colorFromHex("0E122B");
final primaryColorAccent = ClassUtils.colorFromHex("EFFAE7");
const backgroundColor = Colors.white;
final shadowColor = const Color(0xFFB7B7B7).withOpacity(.16);
final shadowColor2 = ClassUtils.colorFromHex("F2EDEA");
final formFieldBackgroundColor = ClassUtils.colorFromHex("F8F7F7");
final greyColor = ClassUtils.colorFromHex("F4F4F6");

const colorAccent = Color(0xFFE9446A);

const primaryDark = Color(0xFFFF9F59);
const colorAccent2 = Color(0xFF385898);
const colorMenu1 = Color(0xFF0B1632);
const colorButtonGmail = Color(0xFF385898);
const colorSelected = "020000";
const noColorSelected = "AAB0B9";
const validBtn = "E9446A";
const invalidBtn = "F9C7D3";
const content_background = "F1F1F3";
// br
SizedBox Br2() => const SizedBox(
      height: 2,
    );
SizedBox Br3() => const SizedBox(
      height: 3,
    );
SizedBox Br5() => const SizedBox(
      height: 5,
    );

SizedBox Br10() => const SizedBox(
      height: 10,
    );
    SizedBox Br15() => const SizedBox(
      height: 15,
    );
SizedBox Br20() => const SizedBox(
      height: 20,
    );
SizedBox Br30() => const SizedBox(
      height: 30,
    );
SizedBox Br40() => const SizedBox(
      height: 40,
    );
SizedBox Br50() => const SizedBox(
      height: 50,
    );
SizedBox w20() => const SizedBox(
      width: 20,
    );
