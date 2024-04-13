// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:kondigbale/classe/connect/connect_check.dart';
// import 'package:kondigbale/classe/onboard.dart';
// import 'package:kondigbale/widget/uiSnackbar.dart';
// import 'package:reorderable_grid_view/reorderable_grid_view.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<int> _items = List.generate(10, (index) => index);
//   final ConnectivityChecker _connectivity = ConnectivityChecker();

//   List<OnboardData> onboardD = [];
//   Future<void> getOnboardData() async {
//     try {
//       final String response =
//           await rootBundle.loadString('assets/json/onboard.json');
//       final List<dynamic> jsonDataList = json.decode(response) as List<dynamic>;

//       setState(() {
//         onboardD =
//             jsonDataList.map((json) => OnboardData.fromJson(json)).toList();
//       });
//       print(jsonDataList);
//     } catch (error) {
//       debugPrint('Erreur lors de la recupperation de l\'api => $error');
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getOnboardData();
//     _verifyConnect();
//   }

//   _verifyConnect() async {
//     bool isConnect = await _connectivity.checkInternetConnectivity();
//     if (isConnect == true) {
//       UiSnackbar.showSnackbar(context, 'Connected', true);
//     } else {
//       UiSnackbar.showSnackbar(context, 'not connected', false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ReorderableGridView.count(
//       crossAxisCount: 3,
//       childAspectRatio: 1.0,
//       onReorder: (int oldIndex, int newIndex) {
//         final OnboardData item = onboardD.removeAt(oldIndex);
//         onboardD.insert(newIndex, item);
//         setState(() {});
//       },
//       children: onboardD.map((OnboardData item) {
//         return Container(
//           key: ValueKey(item.id),
//           child: Card(
//             elevation: 2.0,
//             child: SvgPicture.asset(
//               item.image,
//               height: 50,
//             ),
//           ),
//         );
//       }).toList(),
//     ));
//   }
// }
