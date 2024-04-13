import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class Blue extends StatefulWidget {
  const Blue({super.key}); // Fixed key parameter

  @override
  State<Blue> createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  bool _nfcAvailable = false; // Track NFC availability

  @override
  void initState() {
    super.initState();
    _checkNFCAvailability(); // Check NFC availability when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: ElevatedButton(
          onPressed: _nfcAvailable
              ? _startNFCReading
              : null, // Disable button if NFC is not available
          child: const Text('Start NFC Reading'),
        ),
      ),
    );
  }

  void _checkNFCAvailability() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();

      setState(() {
        _nfcAvailable = isAvailable; // Update NFC availability state
      });

      if (!isAvailable) {
        debugPrint('NFC not available.');
      }
    } catch (e) {
      debugPrint('Error checking NFC availability: $e');
    }
  }

  void _startNFCReading() async {
    try {
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          debugPrint('NFC Tag Detected: ${tag.data}');
          // Handle NFC tag data here
        },
      );
    } catch (e) {
      debugPrint('Error starting NFC session: $e');
    }
  }
}
