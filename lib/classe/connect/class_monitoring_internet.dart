import 'dart:async';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../widget/internet_dialog.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  factory ConnectivityService() => _instance;

  ConnectivityService._internal();

  bool _dialogVisible = false;
  ConnectivityStatus _status = ConnectivityStatus.none;
  late StreamSubscription<ConnectivityStatus> _connectivitySubscription;
  late BuildContext _context;
  void startMonitoring(BuildContext context, Function functionFuture) {
    _context = context;
    ConnectivitySettings.init(lookupDuration: const Duration(seconds: 30));
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      _listenToConnectivityResult(result);
      // Si une connexion est disponible et que la fonction test n'est pas nulle, appelle la fonction
      if (isConnected() && functionFuture != null) {
        functionFuture();
      }
    });
    // Vérifie la connectivité au démarrage
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    _status = await Connectivity().checkConnectivity();
    _listenToConnectivityResult(_status);
  }

  void _listenToConnectivityResult(ConnectivityStatus result) {
    _status = result;
    debugPrint('Connectivity status changed: $result.');
    debugPrint('Is connected: ${isConnected()}.');

    if (!isConnected()) {
      if (!_dialogVisible) {
        _dialogVisible = true;
        _showConnectivityDialog(_context);
      }
    } else {
      if (_dialogVisible) {
        _dialogVisible = false;
        print(1);
      }
    }
  }

  bool isConnected() {
    return _status == ConnectivityStatus.mobile ||
        _status == ConnectivityStatus.wifi;
  }

  Future<void> _showConnectivityDialog(BuildContext context) async {
    await Future.delayed(Duration.zero);
    await showConnectivityDialog(context);
    if (isConnected()) {
      _dialogVisible = false;
    }
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }
}
