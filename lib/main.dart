import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:kondjigbale/classe/localization/locales.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/models/confirm.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/providers/listes_provider.dart';
import 'package:kondjigbale/providers/user_provider.dart';
import 'package:kondjigbale/testparams.dart';
import 'package:kondjigbale/views/agenda/payPage.dart';
import 'package:kondjigbale/views/auth/login_page.dart';

import 'package:go_router/go_router.dart';
import 'package:kondjigbale/views/home/home.dart';
import 'package:kondjigbale/views/preload/onboard_page.dart';

import 'package:kondjigbale/views/preload/splashscreen.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ListesProvider()),
      ChangeNotifierProvider(create: (_) => UsersProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    configureLocalization();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Kondjigbale',
      theme: ThemeData(
        fontFamily: 'Axiformat',
        colorScheme: ColorScheme.fromSeed(seedColor: Kprimary),
        useMaterial3: true,
      ),
      supportedLocales: localization.supportedLocales,
      localizationsDelegates: localization.localizationsDelegates,
      routerConfig: goRouter,
    );
  }

  void configureLocalization() {
    String defaultLanguage = window.locale.languageCode;

    localization.init(mapLocales: LOCALES, initLanguageCode: defaultLanguage);
    localization.onTranslatedLanguage = onTranslatedLanguage;
  }

  void onTranslatedLanguage(Locale? locale) {
    setState(() {});
  }
}

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboard',
      builder: (context, state) =>
          OnboardPage(apiPays: const [], listSexe: const []),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/test',
      builder: (context, state) {
        final extraData = (state.extra as Map<String, dynamic>?)?['text'] ?? "";
        return TestPage(text: extraData);
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        final Map<String, dynamic> extraData =
            state.extra as Map<String, dynamic>;
        final List<Country>? apiPays = extraData['apiPays'];
        final List<Sexe>? listSexe = extraData['listSexe'];
        return LoginPage(apiPays: apiPays ?? [], listSexe: listSexe ?? []);
      },
    ),
    GoRoute(
      path: '/payPage',
      builder: (context, state) {
        final Map<String, dynamic> extraData =
            state.extra as Map<String, dynamic>;
        final Confirm? payResponse = extraData['payResponse'];
        return PayPage(payResponse: payResponse!);
      },
    ),
  ],
);
