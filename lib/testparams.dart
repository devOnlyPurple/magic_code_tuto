import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({super.key, required this.text});
  String text;
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(widget.text)),
    );
  }
}
