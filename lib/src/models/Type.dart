import 'dart:convert';

Type typeFromJson(String response) => Type.fromJson(json.decode(response));

List<Type> typesFromJson(String response) => List<Type>.from(json.decode(response)["types"].map((type) => Type.fromJson(type)));

String typeToJson(Type type) => json.encode(type.toJson());

class Type {
  Type({
    this.id, 
    this.name
  });

  int id;
  String name;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name
  };
}