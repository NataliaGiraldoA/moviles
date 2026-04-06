import 'dart:convert';

class HeroModel {
  HeroModel({
    this.id,
    required this.nombre,
    required this.bio,
    required this.img,
    required this.aparicion,
    required this.casa,
  });

  String? id;
  String nombre;
  String bio;
  String img;
  DateTime aparicion;
  String casa;

  factory HeroModel.fromJson(String str) => HeroModel.fromMap(json.decode(str));

  factory HeroModel.fromMap(Map<String, dynamic> json) => HeroModel(
    id: (json["_id"] ?? json["id"] ?? json["uid"])?.toString(),
    nombre: (json["nombre"] ?? '').toString(),
    bio: (json["bio"] ?? '').toString(),
    img: (json["img"] ?? '').toString(),
    aparicion:
        DateTime.tryParse((json["aparicion"] ?? '').toString()) ??
        DateTime(1900, 1, 1),
    casa: (json["casa"] ?? 'Sin casa').toString(),
  );
}
