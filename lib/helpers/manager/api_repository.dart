import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kondjigbale/models/actu_response.dart';
import 'package:kondjigbale/models/add_rdv_response.dart';
import 'package:kondjigbale/models/adresse_response.dart';
import 'package:kondjigbale/models/conseil_response.dart';
import 'package:kondjigbale/models/crenau_doc_response.dart';
import 'package:kondjigbale/models/doctor_response.dart';
import 'package:kondjigbale/models/menu_response.dart';
import 'package:kondjigbale/models/menu_special_content.dart';
import 'package:kondjigbale/models/pharmacie_response.dart';
import 'package:kondjigbale/models/rdv_confirm_response.dart';
import 'package:kondjigbale/models/rdv_response.dart';
import 'package:kondjigbale/models/register_response.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/manager/api_manager.dart';
import 'package:kondjigbale/helpers/manager/dio_provider.dart';
import 'package:kondjigbale/models/response_listes.dart';
import 'package:kondjigbale/models/response_login.dart';
import 'package:kondjigbale/models/uneAdresse_response.dart';
import 'package:kondjigbale/models/ville_response.dart';

import '../../models/cancel_rdv.dart';

class ApiRepository {
  // login
  // static Future<LoginResponse> login(Map<String, String> datas) async {
  //   Dio dio = await getDio();
  //   LoginResponse responselogin = LoginResponse();

  //   try {
  //     // Attendre que la future soit résolue
  //     datas = await Api.get_default_datas(datas);
  //     print(datas);
  //     FormData formData = FormData.fromMap(datas);

  //     Response response = await dio.post(LOGIN_SERVER_URL, data: formData);
  //     print(response.data);
  //     var data = jsonDecode(response.data);

  //     responselogin = LoginResponse.fromJson(data);
  //     if (response.statusCode == 200) {
  //       var data = json.decode(response.data);
  //       responselogin = LoginResponse.fromJson(data);
  //     }
  //   } catch (e) {
  //     debugPrint(' login api error => $e');
  //   }
  //   return responselogin;
  // }
  static Future<LoginResponse> login(Map<String, String> datas) async {
    Dio dio = await getDio();
    LoginResponse responselogin = LoginResponse();

    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(LOGIN_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse

        responselogin = LoginResponse.fromJson(response.data);
      } else {
        responselogin = LoginResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Si une exception est levée, afficher l'erreur
      debugPrint(' login api error => $e');
      // Créer un objet LoginResponse avec les informations d'erreur
      responselogin = LoginResponse(
        status: 'error',
        message: 'Erreur lors de la connexion: $e',
      );
    }
    return responselogin;
  }

  static Future<LoginResponse> getUserInfo(Map<String, String> datas) async {
    Dio dio = await getDio();
    LoginResponse responselogin = LoginResponse();

    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(USER_INFO_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse

        responselogin = LoginResponse.fromJson(response.data);
      } else {
        responselogin = LoginResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Si une exception est levée, afficher l'erreur
      debugPrint(' login api error => $e');
      // Créer un objet LoginResponse avec les informations d'erreur
      responselogin = LoginResponse(
        status: 'error',
        message: 'Erreur lors de la connexion: $e',
      );
    }
    return responselogin;
  }

  static Future<ListesResponse> listes_api(Map<String, String> datas) async {
    Dio dio = await getDio();
    ListesResponse listesResponse = ListesResponse();
    try {
      datas = await Api.get_default_datas(datas);

      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(LIST_SERVER_URL, data: formData);
      var data = jsonDecode(response.data);

      listesResponse = ListesResponse.fromJson(data);
    } catch (e) {
      debugPrint(
          ' ApiRepository Erreur eu lors de la récupération des données $e');
    }
    return listesResponse;
  }

  // register
  static Future<ResponseSignup> register(Map<String, String> datas) async {
    Dio dio = await getDio();
    ResponseSignup responsesignup = ResponseSignup();
    try {
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);
      Response response = await dio.post(SIGNUP_SERVER_URL, data: formData);
      if (response.statusCode == 200) {
        responsesignup = ResponseSignup.fromJson(response.data);
      }
    } catch (e) {
      debugPrint(' api signup error => $e');
    }
    return responsesignup;
  }
  // confirm-code

  static Future<LoginResponse> confirmation_code(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    LoginResponse responselogin = LoginResponse();

    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(CONFIRM_CODE_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse

        responselogin = LoginResponse.fromJson(response.data);
      } else {
        responselogin = LoginResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Si une exception est levée, afficher l'erreur
      debugPrint(' confirm api error => $e');
      // Créer un objet LoginResponse avec les informations d'erreur
      responselogin = LoginResponse(
        status: 'error',
        message: 'Erreur lors de la confirmation : $e',
      );
    }
    return responselogin;
  }

// confirm_resend_code
  static Future<ResponseSignup> confirmation_resend(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    ResponseSignup responsesignup = ResponseSignup();
    try {
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);
      Response response =
          await dio.post(CONFIRM_CODE_RESEND_SERVER_URL, data: formData);
      if (response.statusCode == 200) {
        responsesignup = ResponseSignup.fromJson(response.data);
      }
    } catch (e) {
      debugPrint(' api resend error => $e');
    }
    return responsesignup;
  }

// forget password
  static Future<ResponseSignup> forget_password(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    ResponseSignup responsesignup = ResponseSignup();
    try {
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);
      Response response =
          await dio.post(PASSWORD_FORGET_SERVER_URL, data: formData);
      if (response.statusCode == 200) {
        responsesignup = ResponseSignup.fromJson(response.data);
      }
    } catch (e) {
      debugPrint(' api forget error => $e');
    }
    return responsesignup;
  }

// reset_password
  static Future<LoginResponse> resetPassword(Map<String, String> datas) async {
    Dio dio = await getDio();
    LoginResponse responselogin = LoginResponse();

    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(PASSWORD_RESET_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse

        responselogin = LoginResponse.fromJson(response.data);
      } else {
        responselogin = LoginResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Si une exception est levée, afficher l'erreur
      debugPrint(' login api error => $e');
      // Créer un objet LoginResponse avec les informations d'erreur
      responselogin = LoginResponse(
        status: 'error',
        message: 'Erreur lors de la connexion: $e',
      );
    }
    return responselogin;
  }

  static Future<LoginResponse> updateUser(Map<String, String> datas) async {
    Dio dio = await getDio();
    LoginResponse responselogin = LoginResponse();

    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(ACCOUNT_UPDATE_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse

        responselogin = LoginResponse.fromJson(response.data);
      } else {
        responselogin = LoginResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Si une exception est levée, afficher l'erreur
      debugPrint(' update api error => $e');
      // Créer un objet LoginResponse avec les informations d'erreur
      responselogin = LoginResponse(
        status: 'error',
        message: 'Erreur lors de update: $e',
      );
    }
    return responselogin;
  }

  static Future<LoginResponse> updatepassword(Map<String, String> datas) async {
    Dio dio = await getDio();
    LoginResponse responselogin = LoginResponse();

    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(PASSWORD_UPDATE_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse

        responselogin = LoginResponse.fromJson(response.data);
      } else {
        responselogin = LoginResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Si une exception est levée, afficher l'erreur
      debugPrint(' update password api error => $e');
      // Créer un objet LoginResponse avec les informations d'erreur
      responselogin = LoginResponse(
        status: 'error',
        message: 'Erreur lors de update: $e',
      );
    }
    return responselogin;
  }

  //
  static Future<ConseilResponse> listConseil(Map<String, String> datas) async {
    Dio dio = await getDio();
    ConseilResponse responseConseil = ConseilResponse();

    // Attendre que la future soit résolue
    datas = await Api.get_default_datas(datas);
    print(datas);
    FormData formData = FormData.fromMap(datas);

    Response response = await dio.post(CONSEIL_SERVER_URL, data: formData);
    print(response.data);

    if (response.statusCode == 200) {
      // Analyser la réponse JSON et créer un objet LoginResponse
      var data = jsonDecode(response.data);
      responseConseil = ConseilResponse.fromJson(data);
    } else {
      responseConseil = ConseilResponse(
        status: response.statusCode.toString(),
        message: 'Erreur de serveur: ${response.statusCode}',
      );
    }

    return responseConseil;
  }

  static Future<ConseilResponse> likeDislikeConseil(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    ConseilResponse responseConseil = ConseilResponse();

    // Attendre que la future soit résolue
    datas = await Api.get_default_datas(datas);
    print(datas);
    FormData formData = FormData.fromMap(datas);

    Response response = await dio.post(LIKE_CONSEIL_SERVER_URL, data: formData);
    print(response.data);

    if (response.statusCode == 200) {
      // Analyser la réponse JSON et créer un objet LoginResponse
      var data = jsonDecode(response.data);
      responseConseil = ConseilResponse.fromJson(data);
    } else {
      responseConseil = ConseilResponse(
        status: response.statusCode.toString(),
        message: 'Erreur de serveur: ${response.statusCode}',
      );
    }

    return responseConseil;
  }

  static Future<ConseilResponse> shareConseil(Map<String, String> datas) async {
    Dio dio = await getDio();
    ConseilResponse responseConseil = ConseilResponse();

    // Attendre que la future soit résolue
    datas = await Api.get_default_datas(datas);
    print(datas);
    FormData formData = FormData.fromMap(datas);

    Response response =
        await dio.post(SHARE_CONSEIL_SERVER_URL, data: formData);
    print(response.data);

    if (response.statusCode == 200) {
      // Analyser la réponse JSON et créer un objet LoginResponse
      var data = jsonDecode(response.data);
      responseConseil = ConseilResponse.fromJson(data);
    } else {
      responseConseil = ConseilResponse(
        status: response.statusCode.toString(),
        message: 'Erreur de serveur: ${response.statusCode}',
      );
    }

    return responseConseil;
  }

  static Future<ConseilResponse> saveConseil(Map<String, String> datas) async {
    Dio dio = await getDio();
    ConseilResponse responseConseil = ConseilResponse();

    // Attendre que la future soit résolue
    datas = await Api.get_default_datas(datas);
    print(datas);
    FormData formData = FormData.fromMap(datas);

    Response response = await dio.post(SAVE_CONSEIL_SERVER_URL, data: formData);
    print(response.data);

    if (response.statusCode == 200) {
      // Analyser la réponse JSON et créer un objet LoginResponse
      var data = jsonDecode(response.data);
      responseConseil = ConseilResponse.fromJson(data);
    } else {
      responseConseil = ConseilResponse(
        status: response.statusCode.toString(),
        message: 'Erreur de serveur: ${response.statusCode}',
      );
    }

    return responseConseil;
  }
  // menus

  static Future<MenuResponse> listMenu(Map<String, String> datas) async {
    Dio dio = await getDio();
    MenuResponse responseMenu = MenuResponse();

    // Attendre que la future soit résolue
    datas = await Api.get_default_datas(datas);
    print(datas);
    FormData formData = FormData.fromMap(datas);

    Response response = await dio.post(MENU_SERVER_URL, data: formData);
    print(response.data);

    if (response.statusCode == 200) {
      // Analyser la réponse JSON et créer un objet LoginResponse
      var data = jsonDecode(response.data);
      responseMenu = MenuResponse.fromJson(data);
    } else {
      responseMenu = MenuResponse(
        status: response.statusCode.toString(),
        message: 'Erreur de serveur: ${response.statusCode}',
      );
    }

    return responseMenu;
  }

  static Future<MenuResponse> listAllMenu(Map<String, String> datas) async {
    Dio dio = await getDio();
    MenuResponse responseMenu = MenuResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(MENU_ALL_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = MenuResponse.fromJson(data);
      } else {
        responseMenu = MenuResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de Menu list =>$e");
    }
    return responseMenu;
  }

  static Future<MenuResponse> addShorcut(Map<String, String> datas) async {
    Dio dio = await getDio();
    MenuResponse responseMenu = MenuResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(ADD_MENU_SHORCUT_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = MenuResponse.fromJson(data);
      } else {
        responseMenu = MenuResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de Menu list =>$e");
    }
    return responseMenu;
  }

  static Future<MenuSpecialResponse> specialMenu(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    MenuSpecialResponse responseMenu = MenuSpecialResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(SPECIAL_MENU_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = MenuSpecialResponse.fromJson(data);
      } else {
        responseMenu = MenuSpecialResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de Menu list =>$e");
    }
    return responseMenu;
  }

  // adresse
  static Future<AdresseResponse> listAdresse(Map<String, String> datas) async {
    Dio dio = await getDio();
    AdresseResponse responseMenu = AdresseResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(ALL_ADRESSE_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = AdresseResponse.fromJson(data);
      } else {
        responseMenu = AdresseResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de adresse list =>$e");
    }
    return responseMenu;
  }

  static Future<UneAdresseResponse> addAdresse(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    UneAdresseResponse responseMenu = UneAdresseResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(ADD_ADRESSE_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = UneAdresseResponse.fromJson(data);
      } else {
        responseMenu = UneAdresseResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de adresse create =>$e");
    }
    return responseMenu;
  }

  static Future<UneAdresseResponse> updateAdresse(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    UneAdresseResponse responseMenu = UneAdresseResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(UPDATE_ADRESSE_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = UneAdresseResponse.fromJson(data);
      } else {
        responseMenu = UneAdresseResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de adresse update =>$e");
    }
    return responseMenu;
  }

  static Future<UneAdresseResponse> deleteAdresse(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    UneAdresseResponse responseMenu = UneAdresseResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(DELETE_ADRESSE_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = UneAdresseResponse.fromJson(data);
      } else {
        responseMenu = UneAdresseResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de adresse update =>$e");
    }
    return responseMenu;
  }

  // villes
  static Future<VilleResponse> listVille(Map<String, String> datas) async {
    Dio dio = await getDio();
    VilleResponse responseMenu = VilleResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(VILLE_LIST_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = VilleResponse.fromJson(data);
      } else {
        responseMenu = VilleResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de ville liste =>$e");
    }
    return responseMenu;
  }

  static Future<PharmaciesResponse> listPharma(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    PharmaciesResponse responseMenu = PharmaciesResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(LIST_PHARMA_SERVER_URL, data: formData);
      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = PharmaciesResponse.fromJson(data);
      } else {
        responseMenu = PharmaciesResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de ville liste =>$e");
    }
    return responseMenu;
  }

  // actualite
  static Future<ActuResponse> listActu(Map<String, String> datas) async {
    Dio dio = await getDio();
    ActuResponse responseMenu = ActuResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(LIST_ACTU_SERVER_URL, data: formData);

      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseMenu = ActuResponse.fromJson(data);
      } else {
        responseMenu = ActuResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de ville liste =>$e");
    }
    return responseMenu;
  }

  //RDV
  static Future<RdvResponse> listRdv(Map<String, String> datas) async {
    Dio dio = await getDio();
    RdvResponse responseRdv = RdvResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(LIST_RDV_SERVER_URL, data: formData);

      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseRdv = RdvResponse.fromJson(data);
      } else {
        responseRdv = RdvResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de rdv liste =>$e");
    }
    return responseRdv;
  }

  // doctor list

  static Future<DoctorResponse> listDoctor(Map<String, String> datas) async {
    Dio dio = await getDio();
    DoctorResponse responseDoctor = DoctorResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(LIST_DOCTOR_SERVER_URL, data: formData);

      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseDoctor = DoctorResponse.fromJson(data);
      } else {
        responseDoctor = DoctorResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {}

    return responseDoctor;
  }

  // creneau

  static Future<NicheDoctorResponse> creneauDoctor(
      Map<String, String> datas) async {
    Dio dio = await getDio();
    NicheDoctorResponse responseDoctor = NicheDoctorResponse();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response =
          await dio.post(HOURS_DOCTOR_SERVER_URL, data: formData);

      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseDoctor = NicheDoctorResponse.fromJson(data);
      } else {
        responseDoctor = NicheDoctorResponse(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {}
    return responseDoctor;
  }

  // add rdv

  static Future<Add_rdv> addRdv(Map<String, String> datas) async {
    Dio dio = await getDio();
    Add_rdv responseRdv = Add_rdv();
    try {
      // Attendre que la future soit résolue
      datas = await Api.get_default_datas(datas);
      print(datas);
      FormData formData = FormData.fromMap(datas);

      Response response = await dio.post(ADD_RDV_SERVER_URL, data: formData);

      print(response.data);

      if (response.statusCode == 200) {
        // Analyser la réponse JSON et créer un objet LoginResponse
        var data = jsonDecode(response.data);
        responseRdv = Add_rdv.fromJson(data);
      } else {
        responseRdv = Add_rdv(
          status: response.statusCode.toString(),
          message: 'Erreur de serveur: ${response.statusCode}',
        );
      }
    } catch (e) {
      debugPrint("erreu de rdv liste =>$e");
    }
    return responseRdv;
  }

  // confirm
  static Future<Confirm_rdv> confirmRdv(Map<String, String> datas) async {
    Dio dio = await getDio();
    Confirm_rdv responseRdv = Confirm_rdv();

    // Attendre que la future soit résolue
    datas = await Api.get_default_datas(datas);
    print(datas);
    FormData formData = FormData.fromMap(datas);

    Response response = await dio.post(CONFIRM_RDV_SERVER_URL, data: formData);

    print(response.data);

    if (response.statusCode == 200) {
      // Analyser la réponse JSON et créer un objet LoginResponse
      var data = jsonDecode(response.data);
      responseRdv = Confirm_rdv.fromJson(data);
    } else {
      responseRdv = Confirm_rdv(
        status: response.statusCode.toString(),
        message: 'Erreur de serveur: ${response.statusCode}',
      );
    }

    return responseRdv;
  }

  // cancel

  static Future<CancelRdv> cancelRdv(Map<String, String> datas) async {
    Dio dio = await getDio();
    CancelRdv responseRdv = CancelRdv();

    // Attendre que la future soit résolue
    datas = await Api.get_default_datas(datas);
    print(datas);
    FormData formData = FormData.fromMap(datas);

    Response response = await dio.post(CANCEL_RDV_SERVER_URL, data: formData);

    print(response.data);

    if (response.statusCode == 200) {
      // Analyser la réponse JSON et créer un objet LoginResponse
      var data = jsonDecode(response.data);
      responseRdv = CancelRdv.fromJson(data);
    } else {
      responseRdv = CancelRdv(
        status: response.statusCode.toString(),
        message: 'Erreur de serveur: ${response.statusCode}',
      );
    }

    return responseRdv;
  }

  // delete

  static Future<CancelRdv> deletelRdv(Map<String, String> datas) async {
    Dio dio = await getDio();
    CancelRdv responseRdv = CancelRdv();

    // Attendre que la future soit résolue
    datas = await Api.get_default_datas(datas);
    print(datas);
    FormData formData = FormData.fromMap(datas);

    Response response = await dio.post(DELETE_RDV_SERVER_URL, data: formData);

    print(response.data);

    if (response.statusCode == 200) {
      // Analyser la réponse JSON et créer un objet LoginResponse
      var data = jsonDecode(response.data);
      responseRdv = CancelRdv.fromJson(data);
    } else {
      responseRdv = CancelRdv(
        status: response.statusCode.toString(),
        message: 'Erreur de serveur: ${response.statusCode}',
      );
    }

    return responseRdv;
  }
}
