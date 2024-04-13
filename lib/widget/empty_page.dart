// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:kondjigbale/helpers/constants/constant.dart';

class EmptyPage extends StatelessWidget {
  EmptyPage({super.key, required this.title});
  String title;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Br50(),
          Br50(),
          Image.asset(
            "assets/icons/empty.png",
            width: size.width / 1,
            height: 250,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
              children: [
                Br10(),
                Text(title,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: kBlack,
                        // fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
