//flutter pub add flutter_secure_storage

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBcytoCbDUARrX8eHpcR-Bdrdq0yUmSjf8';

  final String _baseUrlLocal = 'rest-sorella-production.up.railway.app';

  final storage = FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

// Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUserLocal(
  String correo, 
  String password, 
  String nombre,
  String img ,
  String rol,
  bool google
  ) async {
    final Map<String, dynamic> authData = {
      'correo': correo,
      'password': password,
      'nombre': nombre,
      'img': img,
      'rol': rol,
      'google': google,
      //'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrlLocal, '/api/usuarios', {
      //'key': _firebaseToken,
    });

    //Envia la peticion
    final resp = await http.post(
      url, 
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData)
    );

    //Decodifica la respuesta
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    /*
    if (decodedResp.containsKey('idToken')) {
      // Token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
    */

    if (decodedResp.containsKey('errors')) {
      //print("Errores:");
      //print(decodedResp['errors']);

      final List<dynamic> errores = decodedResp['errors'];

      // Recorrer los errores
      for (var error in errores) {
        final String mensaje = error['msg'] ?? 'Error desconocido';
        final String campo = error['path'] ?? 'campo desconocido';

        //print('Error en "$campo": $mensaje');

        return 'Error en "$campo": $mensaje';
      }
    } else {
      //print("No hay errores en la respuesta.");
      var ok = decodedResp['ok'] ?? false;
      //print(ok);
      if (!ok) {
    
        final String mensaje = decodedResp['msg'] ?? 'Error desconocido';
        //print('Error en la autenticación: $mensaje');
        return 'Error en la autenticación: $mensaje';
        
      } else {
        //print('Autenticación correcta');
        
        /*
        if (decodedResp.containsKey('token')) {
          // Token hay que guardarlo en un lugar seguro
          // decodedResp['idToken'];
          await storage.write(key: 'token', value: decodedResp['token']);
          return null;
        }
        */
        return null;


      }
    }
    return null;
    


  }



  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken,
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Token hay que guardarlo en un lugar seguro
      // decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> loginLocal(String correo, String password) async {

    final Map<String, dynamic> authData = {
      'correo': correo,
      'password': password,
      //'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrlLocal, '/api/usuarios/login', {
      //'key': _firebaseToken,
    });

    // Envia la peticion
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(authData),
    );

    // Decodifica la respuesta
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print("Respuesta:");
    //print(decodedResp);

    //print(decodedResp.containsKey('token'));
    //print(decodedResp.containsKey('ok'));
    //print(decodedResp.containsKey('errors'));


    if (decodedResp.containsKey('errors')) {
      //print("Errores:");
      //print(decodedResp['errors']);

      final List<dynamic> errores = decodedResp['errors'];

      // Recorrer los errores
      for (var error in errores) {
        final String mensaje = error['msg'] ?? 'Error desconocido';
        final String campo = error['path'] ?? 'campo desconocido';

        //print('Error en "$campo": $mensaje');

        return 'Error en "$campo": $mensaje';
      }
    } else {
      //print("No hay errores en la respuesta.");
      var ok = decodedResp['ok'] ?? false;
      //print(ok);
      if (!ok) {
    
        final String mensaje = decodedResp['msg'] ?? 'Error desconocido';
        //print('Error en la autenticación: $mensaje');
        return 'Error en la autenticación: $mensaje';
        
      } else {
        //print('Autenticación correcta');
        if (decodedResp.containsKey('token')) {
          // Token hay que guardarlo en un lugar seguro
          // decodedResp['idToken'];
          await storage.write(key: 'token', value: decodedResp['token']);
          return null;
        }
      }
    }
    return null;
    
    //return null;

  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
