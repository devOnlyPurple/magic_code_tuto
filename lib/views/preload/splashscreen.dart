import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:kondjigbale/classe/connect/connect_check.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/constants/widget_constants.dart';
import 'package:kondjigbale/helpers/manager/api_repository.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/helpers/utils/connection_status.dart';
import 'package:kondjigbale/helpers/utils/sizeconfig.dart';
import 'package:kondjigbale/models/categorie_blog.dart';
import 'package:kondjigbale/models/categorie_conseil.dart';
import 'package:kondjigbale/models/groupe_sanguin.dart';
import 'package:kondjigbale/models/langue.dart';

import 'package:kondjigbale/models/response_listes.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/models/specialite.dart';
import 'package:kondjigbale/models/type_consultation.dart';
import 'package:kondjigbale/models/type_rdv.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/providers/user_provider.dart';
import 'package:kondjigbale/views/auth/login_page.dart';
import 'package:kondjigbale/views/preload/choose_language.dart';
import 'package:kondjigbale/views/preload/onboard_page.dart';
import 'package:kondjigbale/widget/widget_helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ConnectivityChecker _connectivity = ConnectivityChecker();
  final ClassUtils classUtils = ClassUtils();
  final ClassUtils _classUtils = ClassUtils();
  List<Sexe> listSexe = [];
  List<CategorieConseil> listCategorieConseil = [];
  List<GroupeSanguin> listSanguinGroup = [];
  List<CategorieBlog> listcatblog = [];
  List<TypeConsultation> typeConsultations = [];
  List<Langue> langues = [];
  List<Specialite> specialites = [];
  List<TypeRdv> typeRdvArray = [];
  String? defaultCountry;
  getApiList() async {
    bool isConnect = await _connectivity.checkInternetConnectivity();
    try {
      if (isConnect) {
        print('connecté');

        final Map<String, String> dataLogin = {
          'type_liste': "",
        };

        ListesResponse listesResponse =
            await ApiRepository.listes_api(dataLogin);
        print(listesResponse.toJson());
        if (listesResponse.status == API_SUCCES_STATUS) {
          // ListesProvider _listeProvider = ListesProvider();
          // _listeProvider.pays = listesResponse.information!.pays!;
          List<Country> listPays = [];

          var countriess = countries;
          setState(() {
            listSexe = listesResponse.information!.sexe!;
            defaultCountry = listesResponse.information!.defaultCountry!;
            listCategorieConseil =
                listesResponse.information!.categoriesConseil!;
            listSanguinGroup = listesResponse.information!.groupeSanguins!;
            listcatblog = listesResponse.information!.categoriesBlog!;
            typeConsultations = listesResponse.information!.typeConsultations!;
            langues = listesResponse.information!.langues!;
            specialites = listesResponse.information!.specialites!;
            typeRdvArray = listesResponse.information!.typeRdvArray!;
          });
          // _listeProvider.setlistcatblog(listcatblog);
          // _listeProvider.listcatblog = listcatblog;

          if (listesResponse.information!.pays!.isNotEmpty) {
            for (var element in countriess) {
              for (var filteredc in listesResponse.information!.pays!) {
                if (filteredc.nomAbrev == element.code) {
                  setState(() {
                    listPays.add(element);
                  });
                }
              }
            }
          }

          _goTo(
              listPays,
              listSexe,
              defaultCountry!,
              listCategorieConseil,
              listSanguinGroup,
              listcatblog,
              typeConsultations,
              langues,
              specialites,
              typeRdvArray);
        } else {
          print(listesResponse.message);
          CustomErrorDialog(
            context,
            content: "Une erreure s'est produite. Veuillez réessayer",
            buttonText: "Réessayez",
            onPressed: () {
              getAllListData();
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        print("no connexion");
        CustomErrorDialog(
          context,
          content: "Vérifiez votre connexion internet",
          buttonText: "Réessayez",
          onPressed: () {
            getAllListData();
            Navigator.of(context).pop();
          },
        );
      }
    } catch (e) {
      debugPrint('=>$e');
    }
  }

  void getAllListData() async {
    final PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      getApiList();
    } else if (status.isDenied) {
      // ignore: use_build_context_synchronously

      CustomErrorDialog(
        context,
        content: "Vérifiez vos paramètres de localisation",
        buttonText: "Réessayez",
        onPressed: () async {
          await Geolocator.requestPermission();
          getAllListData();
          Navigator.of(context).pop();
        },
      );
    } else if (status.isPermanentlyDenied) {
      // L'utilisateur a refusé la permission de manière permanente. Vous pouvez l'orienter vers les paramètres de l'application pour qu'il puisse l'activer manuellement.
      // ignore: use_build_context_synchronously

      CustomErrorDialog(
        context,
        content: "Vérifiez vos paramètres de localisation",
        buttonText: "Réessayez",
        onPressed: () {
          getAllListData();
          Navigator.of(context).pop();
        },
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllListData();
    // _getUserInformation();
  }

  @override
  Widget build(BuildContext context) {
    final liste = Provider.of<ListesProvider>(context, listen: false);

    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: Ksplash,
        body: Center(
          child: Image.asset(LOGO_GREEN,
              width: SizeConfig.safeBlockHorizontal * 35),
        ));
  }

  _goTo(
    List<Country> listPays,
    List<Sexe> listSexe,
    String defaultcountry,
    List<CategorieConseil> listeConseil,
    List<GroupeSanguin> listSanguinGroup,
    List<CategorieBlog> listecatblog,
    List<TypeConsultation> consultationType,
    List<Langue> langues,
    List<Specialite> specialite,
    List<TypeRdv> rendevous,
  ) async {
    const storage = FlutterSecureStorage();
    String? statusString = await storage.read(key: 'connectionStatus');
    ConnectionStatus status = ConnectionStatus.unknown;
    final liste = Provider.of<ListesProvider>(context, listen: false);
    final user = Provider.of<UsersProvider>(context, listen: false);
    liste.country = listPays;
    liste.sexe = listSexe;
    liste.countryDefault = defaultcountry;
    liste.catConseil = listeConseil;
    liste.sanguinGroup = listSanguinGroup;
    liste.listcatblog = listcatblog;
    liste.consultationtype = consultationType;
    liste.langueList = langues;
    liste.specialiteList = specialite;
    liste.rendevous = rendevous;
    if (statusString != null) {
      if (statusString == 'connected') {
        status = ConnectionStatus.connected;
      } else if (statusString == 'disconnected') {
        status = ConnectionStatus.disconnected;
      } else if (statusString == 'incompleted') {
        status = ConnectionStatus.incompleted;
      } else if (statusString == 'first') {
        status = ConnectionStatus.first;
      } else if (statusString == 'welcome') {
        status = ConnectionStatus.welcome;
      }
      if (status == ConnectionStatus.welcome) {
        print(100);
        ClassUtils.navigateTo(
            context,
            ChooseLanguage(
              apiPays: listPays,
              listSexe: listSexe,
            ));
        // navigateTo('langue', listPays);
      }
      // Comparer la valeur d'énumération avec ConnectionStatus.connected
      if (status == ConnectionStatus.connected) {
        print('conn');

        _classUtils.getUserInformation().then((value) {
          setState(() {
            user.userInfo = value;
          });
          print(user.userResponse);
          navigateTo('home');
        });

        // ClassUtils.navigateTo(
        //     context,
        //     LoginPage(
        //       listSexe: listSexe,
        //       apiPays: listPays,
        //     ));
      } else if (status == ConnectionStatus.disconnected) {
        ClassUtils.navigateTo(
            context,
            LoginPage(
              listSexe: listSexe,
              apiPays: listPays,
            ));
      } else if (status == ConnectionStatus.incompleted) {
        // liste.setsexe(listSexe);
        ClassUtils.navigateTo(
            context,
            LoginPage(
              listSexe: listSexe,
              apiPays: listPays,
            ));
      } else if (status == ConnectionStatus.first) {
        ClassUtils.navigateTo(
            context,
            OnboardPage(
              apiPays: listPays,
              listSexe: listSexe,
            ));
      }
    } else {
      await storage.write(key: 'connectionStatus', value: 'welcome');
      print(100);
      ClassUtils.navigateTo(
          context,
          ChooseLanguage(
            apiPays: listPays,
            listSexe: listSexe,
          ));
      // navigateTo('langue', listPays);
    }
  }

  navigateTo(String page) {
    GoRouter.of(context).pushReplacement(
      '/$page',
    );
  }
}
