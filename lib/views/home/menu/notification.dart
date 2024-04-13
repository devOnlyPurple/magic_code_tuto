import 'package:flutter/material.dart';
import 'package:kondjigbale/widget/empty_page.dart';

class NotifactionPage extends StatefulWidget {
  const NotifactionPage({super.key});

  @override
  State<NotifactionPage> createState() => _NotifactionPageState();
}

class _NotifactionPageState extends State<NotifactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification "),
      ),
      body: EmptyPage(title: 'Aucune.s notification.s'),
    );
  }
}
