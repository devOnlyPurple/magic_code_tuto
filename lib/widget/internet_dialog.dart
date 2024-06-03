import 'package:app_settings/app_settings.dart';
import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter/material.dart';

Future<void> showConnectivityDialog(BuildContext context) async {
  Size size = MediaQuery.of(context).size;

  // Créer un booléen pour garder une trace de la connexion
  bool isConnected = false;

  // Écouter les changements de connectivité pour mettre à jour le booléen
  Connectivity().onConnectivityChanged.listen((status) {
    isConnected = (status == ConnectivityStatus.mobile ||
        status == ConnectivityStatus.wifi);
    // S'il y a une connexion, ferme le dialogue
    if (isConnected) {
      Navigator.of(context).pop();
    }
  });

  await showDialog<Object?>(
    context: context,
    barrierDismissible:
        false, // Empêcher le dialogue de se fermer lors de l'appui sur le bouton de retour
    builder: (_) {
      return WillPopScope(
        onWillPop: () async =>
            false, // Empêcher le dialogue de se fermer lors de l'appui sur le bouton de retour
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: size.width * 0.95,
            height: size.height * 0.36,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Connection lost',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '''It appears that you are not connected to the Internet. Please check your connection settings.''',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    // Go to settings using app_settings package.
                    onPressed: () {
                      AppSettings.openAppSettings(
                          type: AppSettingsType.wireless);
                    },
                    child: const Text(
                      'Paramètres',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
