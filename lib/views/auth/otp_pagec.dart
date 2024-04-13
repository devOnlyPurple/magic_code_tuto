// // ignore_for_file: unused_field, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:kondigbale/helpers/constants/constant.dart';

// class OtpPage extends StatefulWidget {
//   const OtpPage({super.key});

//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }

// class _OtpPageState extends State<OtpPage> {
//   final _container1 = TextEditingController();
//   final _container2 = TextEditingController();
//   final _container3 = TextEditingController();
//   final _container4 = TextEditingController();
//   final _container5 = TextEditingController();
//   FocusNode field1 = FocusNode();
//   FocusNode field2 = FocusNode();
//   FocusNode field3 = FocusNode();
//   FocusNode field4 = FocusNode();
//   FocusNode field5 = FocusNode();
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     field1.dispose();
//     field2.dispose();
//     field3.dispose();
//     field4.dispose();
//     field5.dispose();
//     super.dispose();
//     // _timer.cancel();
//   }

//   int i = 1;
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(15.0),
//             child:
//                 Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//               Br30(),
//               const Text(
//                 "Vérification",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
//               ),
//               Br50(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   pinInput(size, true, false, _container1),
//                   pinInput(size, false, false, _container2),
//                   pinInput(size, false, false, _container3),
//                   pinInput(size, false, false, _container4),
//                   pinInput(size, false, true, _container5),
//                 ],
//               )
//             ]),
//           ),
//         ),
//       ),
//     );
//   }

//   Container pinInput(Size size, bool first, bool last, final controller) {
//     return Container(
//       width: size.width / 8,
//       padding: EdgeInsets.only(right: 10.0),
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: TextFormField(
//         maxLength: 1,
//         autofocus: true,
//         // readOnly: true,
//         keyboardType: TextInputType.number,
//         controller: controller,
//         // obscureText: obscuretext,
//         textAlign: TextAlign.center,

//         style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),

//         decoration: InputDecoration(
//           counterText: '',
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: BorderSide(color: kformFieldBackgroundColor),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: BorderSide(
//               color: kformFieldBackgroundColor,
//             ),
//           ),
//           fillColor: kformFieldBackgroundColor,
//           filled: true,
//           border: OutlineInputBorder(
//               // borderSide: new BorderSide(color:Colors.green)
//               ),
//           hintText: '',
//           hintStyle:
//               TextStyle(fontSize: 14.0, color: Colors.grey.withOpacity(0.5)),
//           prefixText: ' ',
//         ),
//         onChanged: (value) {
//           if (value.length == 1 && last == false) {
//             FocusScope.of(context).nextFocus();
//           } else if (value.isEmpty && first == false) {
//             FocusScope.of(context).previousFocus();
//           } else if (value.isNotEmpty &&
//               first == true &&
//               _container1.text.isEmpty) {
//             FocusScope.of(context).nextFocus();
//           } else if (value.isEmpty && controller != _container1) {
//             FocusScope.of(context).previousFocus();
//             print(1);
//           } else {
//             print(1);
//           }
//         },
//       ),
//     );
//   }
// }
