import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({
    super.key,
    required this.title,
    required this.colorBtn,
    required this.clickBtn,
    required this.hsizeBtn,
    this.wsizeBtn,
    required this.colorText,
  });
  String title;
  Color colorBtn;
  Color colorText;
  final VoidCallback clickBtn;
  double hsizeBtn;
  double? wsizeBtn;
  @override
  Widget build(BuildContext context) {
    final sp = MediaQuery.of(context).textScaleFactor;

    return InkWell(
      onTap: clickBtn,
      child: Container(
        height: hsizeBtn,
        width: wsizeBtn,
        decoration: BoxDecoration(
            color: colorBtn,
            borderRadius: const BorderRadius.all(Radius.circular(15))),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 17 * sp,
                color: colorText,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
