// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'classe/connect/class_monitoring_internet.dart';
import 'widget/internet_dialog.dart';

class TestPage extends StatefulWidget {
  TestPage({super.key, required this.text});
  String text;
  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ConnectivityService().startMonitoring(context, _listentest);
    _retrieveCalendars();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ConnectivityService().dispose();
  }

  Future<void> _listentest() async {
    print('okkkk');
  }

  void _listentestIfConnected() {
    if (ConnectivityService().isConnected()) {
      _listentest();
    }
  }

  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  late List<Calendar> _calendars;
  late Calendar _selectedCalendar;
  Future<void> _retrieveCalendars() async {
    var status = await Permission.calendar.status;
    if (status.isDenied) {
      status = await Permission.calendar.request();
    }

    // Si les autorisations sont accordées, récupérez les calendriers
    if (status.isGranted) {
      try {
        var calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
        if (calendarsResult?.isSuccess ?? false) {
          setState(() {
            _calendars = calendarsResult?.data ?? [];
            if (_calendars.isNotEmpty) {
              _selectedCalendar = _calendars.first;
            }
          });
        } else {
          // Gérez le cas où la récupération des calendriers échoue
          print('Échec de la récupération des calendriers');
        }
      } catch (e) {
        // Gérez les exceptions lors de la récupération des calendriers
        print('Erreur lors de la récupération des calendriers: $e');
      }
    } else {
      // Gérez le cas où l'utilisateur refuse les autorisations
      print('Les autorisations d\'accès au calendrier ont été refusées');
    }
  }

  // Future<void> _addEvent() async {
  //   final event = Event(
  //     _selectedCalendar.id,
  //     title: 'Nouvel Événement',
  //     description: 'Description de l\'événement',
  //     start: DateTime.now(),
  //     end: DateTime.now().add(Duration(hours: 1)),
  //   );
  //   await _deviceCalendarPlugin.createOrUpdateEvent(event);
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }
}
