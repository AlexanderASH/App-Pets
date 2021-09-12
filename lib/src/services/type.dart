import 'package:app_pets/src/models/Type.dart';
import 'package:flutter/services.dart';

class TypeService {

  static Future<List<Type>> getTypes() async {
    try {
      final String response = await rootBundle.loadString('assets/types.json');
      return typesFromJson(response);
    } catch (e) {
      throw Exception(e.message);
    }
  }
}