// VarMethodProvider.dart

import 'package:flutter/foundation.dart';

class VarMethodProvider extends ChangeNotifier {
  static final VarMethodProvider _instance = VarMethodProvider._internal();

  factory VarMethodProvider() {
    return _instance;
  }

  VarMethodProvider._internal();
  int _payed = 0; // 0 payed , 1 not payed
  // NotificationDetails? _details;
  int get payed => _payed;

  set determine(int newstatus) {
    _payed = newstatus;
    notifyListeners();
  }
}
