import 'dart:io';

import 'package:app_pets/src/commons/utils/constants.dart';

class ConfigHttp {

  static Uri getUri({String path, Map<String, dynamic>queryParameters = const {}}) {
    return Uri(
      host: HOST,
      path: path,
      port: PORT,
      scheme: PROTOCOL,
      queryParameters: queryParameters
    );
  }

  static Map<String, String> getHeaders() {
    return <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };
  }
}