import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Red extends StatefulWidget {
  const Red({super.key});

  @override
  State<Red> createState() => _RedState();
}

class _RedState extends State<Red> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Container(
          child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context)
                    .go('/test', extra: <String, dynamic>{'text': "okayyy"});
              },
              child: const Text('data')),
        ),
      ),
    );
  }
}
