import 'dart:convert';

Pet petFromJson(String response) => Pet.fromJson(json.decode(response));

List<Pet> petsFromJson(String response) => List<Pet>.from((json.decode(response).map((pet) => Pet.fromJson(pet))));

String petToJson(Pet pet) => json.encode(pet.toJson());

class Pet {
  Pet({
    this.name,
    this.description,
    this.color,
    this.size,
    this.image,
    this.gender,
    this.typeId,
  });

  String name;
  String description;
  String color;
  String size;
  String image;
  String gender;
  int typeId;

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    name: json["name"],
    description: json["description"],
    color: json["color"],
    size: json["size"],
    image: json["image"],
    gender: json["gender"],
    typeId: json["typeId"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "color": color,
    "size": size,
    "image": image,
    "gender": gender,
    "typeId": typeId
  };
}
