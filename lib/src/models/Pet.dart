import 'dart:convert';

import 'package:app_pets/src/models/Type.dart';

Pet petFromJson(String response) => Pet.fromJson(json.decode(response));

FetchPet petsFromJson(String response) {
  var data = json.decode(response);
  List<Pet> pets = List<Pet>.from((data["pets"].map((pet) => Pet.fromJson(pet))));
  int count = data["count"];

  return FetchPet(
    pets: pets, 
    count: count
  );
}

String petToJson(Pet pet) => json.encode(pet.toJson());

class Pet {
  Pet({
    this.id,
    this.name,
    this.description,
    this.color,
    this.size,
    this.image,
    this.gender,
    this.typeId,
    this.type
  });

  int id;
  String name;
  String description;
  String color;
  String size;
  String image;
  String gender;
  Type type;
  int typeId;

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    color: json["color"],
    size: json["size"],
    image: json["image"],
    gender: json["gender"],
    typeId: json["typeId"],
    type: Type.fromJson(json["type"])
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "color": color,
    "size": size,
    "image": image,
    "gender": gender,
    "typeId": typeId,
    "type": typeToJson(type)
  };
}

class FetchPet {
  FetchPet({
    this.pets,
    this.count
  });

  List<Pet> pets;
  int count;
}
