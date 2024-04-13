// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';
import 'package:kondjigbale/helpers/utils/class_utils.dart';
import 'package:kondjigbale/models/onboarding_data.dart';
import 'package:kondjigbale/models/sexe.dart';
import 'package:kondjigbale/views/auth/login_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardPage extends StatefulWidget {
  OnboardPage({super.key, required this.apiPays, required this.listSexe});
  List<Country>? apiPays;
  List<Sexe>? listSexe;
  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  PageController pageController = PageController();
  final storage = const FlutterSecureStorage();
  bool isLastPage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.apiPays);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            onPageChanged: (index) {
              setState(() => isLastPage = index == 3);
            },
            children: onboarding_data.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(e["image"]),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.75), BlendMode.darken)),
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.5,
                        child: Text(
                          e["title"],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                        child: InkWell(
                      onTap: () async {
                        if (isLastPage) {
                          await storage.write(
                              key: 'connectionStatus', value: 'incompleted');
                          ClassUtils.navigateTo(
                              context,
                              LoginPage(
                                apiPays: widget.apiPays,
                                listSexe: widget.listSexe,
                              ));
                        } else {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 14,
                        decoration: BoxDecoration(
                            color: Kprimary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(6)),
                        child: Center(
                          child: Text(
                            isLastPage ? "Terminer" : "Suivant",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 6,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Column(
            children: [
              const Spacer(),
              Center(
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: 4,
                  //to click on dots and move
                  onDotClicked: (index) => pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  ),
                  effect: const WormEffect(
                      dotHeight: 7,
                      dotWidth: 7,
                      activeDotColor: Kprimary,
                      dotColor: kGrey),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 12,
              )
            ],
          ),
        ],
      ),
    );
  }
}
