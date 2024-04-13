import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/services.dart';
import 'package:kondjigbale/helpers/constants/api_constant.dart';

Future<Dio> getDio() async {
  Dio dio = Dio();

  dio.options.headers['apiKey'] = API_KEY;

  // Ajout du certificat
  ByteData cert = await rootBundle.load("assets/cert/kondjigbale.crt");
  dio.httpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      final SecurityContext scontext = SecurityContext();

      scontext.useCertificateChainBytes(cert.buffer.asUint8List());

      HttpClient client = HttpClient(context: scontext);

      return client;
    },
  );
  return dio;
}
