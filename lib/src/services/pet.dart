
import 'package:app_pets/src/commons/utils/constants.dart';
import 'package:app_pets/src/models/Pet.dart';
import 'package:app_pets/src/commons/utils/configHttp.dart';
import 'package:http/http.dart' as http;

class PetService {
  static Future<void> create(Pet pet) async {
    try {
      final response = await http.post(
        ConfigHttp.getUri(path: PETS),
        body: petToJson(pet),
        headers: ConfigHttp.getHeaders()
      );

      if (response.statusCode == 500) {
        throw Exception("Try again");
      }
    } catch (e) {
      throw Exception(e.message);
    }
  }

  static Future<FetchPet> getPets(Map<String, dynamic> query) async {
    try {
      final response = await http.get(
        ConfigHttp.getUri(
          path: PETS, 
          queryParameters: query
        ),
        headers: ConfigHttp.getHeaders()
      );

      return petsFromJson(response.body);
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }
}