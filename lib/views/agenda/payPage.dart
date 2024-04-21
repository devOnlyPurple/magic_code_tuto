import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';
import 'package:kondjigbale/models/confirm.dart';

class PayPage extends StatefulWidget {
  PayPage({super.key, required this.payResponse});
  Confirm payResponse;
  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  @override
  Widget build(BuildContext context) {
    return CinetPayCheckout(
        titleStyle: const TextStyle(fontSize: 17),
        title: widget.payResponse.description,
        configData: <String, dynamic>{
          'apikey': widget.payResponse.cinetApikey,
          'site_id': widget.payResponse.cinetSiteId,
          'notify_url': widget.payResponse.notifyUrl
        },
        paymentData: <String, dynamic>{
          'transaction_id': widget.payResponse.transactionId,
          'amount': widget.payResponse.amount,
          'currency': widget.payResponse.currency,
          'channels': widget.payResponse.channels,
          'description': widget.payResponse.description,
        },
        waitResponse: (response) {
          print(response);
        },
        onError: (error) {
          print(error);
        });
  }
}
