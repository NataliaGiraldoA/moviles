import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_peliculas202601/models/models.dart';

class HeroService extends ChangeNotifier {
  final String _baseUrlLocal = 'apirestbd-production.up.railway.app';

  final storage = FlutterSecureStorage();

  String _extractApiError(http.Response resp, {required bool isLogin}) {
    dynamic decoded;
    try {
      decoded = json.decode(resp.body);
    } catch (_) {
      if (resp.statusCode >= 500) {
        return 'El servidor no esta disponible en este momento. Intenta mas tarde.';
      }
      return 'No se pudo interpretar la respuesta del servidor.';
    }

    if (decoded is Map<String, dynamic>) {
      if (decoded['errors'] is List && (decoded['errors'] as List).isNotEmpty) {
        final firstError = (decoded['errors'] as List).first;
        if (firstError is Map<String, dynamic>) {
          final msg = firstError['msg']?.toString() ?? 'Error desconocido';
          final field = firstError['path']?.toString();
          if (field != null && field.isNotEmpty) {
            return 'Error en el campo "$field": $msg';
          }
          return 'Error: $msg';
        }
      }

      if (decoded.containsKey('msg')) {
        return 'Error: ${decoded['msg']}';
      }
    }

    if (resp.statusCode >= 500) {
      return 'El servidor no esta disponible en este momento. Intenta mas tarde.';
    }

    return 'No se pudo completar la solicitud.';
  }

  Future<String?> createHero(
    String nombre,
    String bio,
    String img,
    DateTime aparicion,
    String casa,
  ) async {
    final url = Uri.https(_baseUrlLocal, '/api/heroes/');
    final token = await storage.read(key: 'token');

    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''},
        body: jsonEncode({
          'nombre': nombre,
          'bio': bio,
          'img': img,
          'aparicion': '${aparicion.year}-${aparicion.month.toString().padLeft(2, '0')}-${aparicion.day.toString().padLeft(2, '0')}',
          'casa': casa,
        }),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        return null; // Hero created successfully
      } else {
        return _extractApiError(resp, isLogin: false);
      }
    } catch (e) {
      return 'Ocurrió un error al conectar con el servidor. Intenta de nuevo más tarde.';
    }
  }

  Future<List<HeroModel>> fetchHeroes() async {
    final url = Uri.https(_baseUrlLocal, '/api/heroes/');
    final token = await storage.read(key: 'token');

    try {
      final resp = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''},
      );

      if (resp.statusCode == 200) {
        final dynamic decoded = json.decode(resp.body);

        if (decoded is List) {
          return decoded
              .whereType<Map<String, dynamic>>()
              .map(HeroModel.fromMap)
              .toList();
        }

        if (decoded is Map<String, dynamic> && decoded['heroes'] is List) {
          final heroes = decoded['heroes'] as List;
          return heroes
              .whereType<Map<String, dynamic>>()
              .map(HeroModel.fromMap)
              .toList();
        }

        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final heroes = decoded['data'] as List;
          return heroes
              .whereType<Map<String, dynamic>>()
              .map(HeroModel.fromMap)
              .toList();
        }

        throw Exception('Formato de respuesta no valido para heroes.');
      } else {
        throw Exception(_extractApiError(resp, isLogin: false));
      }
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception(
        'Ocurrió un error al conectar con el servidor. Intenta de nuevo más tarde.',
      );
    }
  }

  Future<String?> deleteHero(String id) async {
    final url = Uri.https(_baseUrlLocal, '/api/heroes/$id');
    final token = await storage.read(key: 'token');

    try {
      final resp = await http.delete(
        url,
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''},
      );
      if (resp.statusCode == 200) {
        return null; // Hero deleted successfully
      } else {
        return _extractApiError(resp, isLogin: false);
      }
    } catch (e) {
      return 'Ocurrió un error al conectar con el servidor. Intenta de nuevo más tarde.';
    }
  }

  Future<String?> updateHero(
    String id,
    String nombre,
    String bio,
    String img,
    DateTime aparicion,
    String casa,
  ) async {
    final url = Uri.https(_baseUrlLocal, '/api/heroes/$id');
    final token = await storage.read(key: 'token');

    try {
      final resp = await http.put(
        url,
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''},
        body: jsonEncode({
          'nombre': nombre,
          'bio': bio,
          'img': img,
          'aparicion': '${aparicion.year}-${aparicion.month.toString().padLeft(2, '0')}-${aparicion.day.toString().padLeft(2, '0')}',
          'casa': casa,
        }),
      );

      if (resp.statusCode == 200) {
        return null; // Hero updated successfully
      } else {
        return _extractApiError(resp, isLogin: false);
      }
    } catch (e) {
      return 'Ocurrió un error al conectar con el servidor. Intenta de nuevo más tarde.';
    }
  }
}
