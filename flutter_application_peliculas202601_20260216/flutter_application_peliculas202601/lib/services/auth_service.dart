import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;




class AuthService extends ChangeNotifier {


 final String _baseUrlLocal = 'apirestbd-production.up.railway.app';


 final storage = FlutterSecureStorage();

 String _normalizeMessage(String message, {required bool isLogin}) {
   final lower = message.toLowerCase();

   if (lower.contains('hable con el administrador')) {
     return 'No pudimos procesar la solicitud por el momento. Intenta de nuevo en unos minutos.';
   }

   if (lower.contains('correo') &&
       (lower.contains('registrado') ||
        lower.contains('existe') ||
        lower.contains('duplic'))) {
     if (isLogin) {
       return 'Correo o contrasena incorrectos.';
     }
     return 'Ese correo ya esta registrado. Inicia sesion o usa otro correo.';
   }

   if (isLogin &&
       (lower.contains('credenciales') ||
        lower.contains('contrasena') ||
        lower.contains('password') ||
        lower.contains('no existe'))) {
     return 'Correo o contrasena incorrectos.';
   }

   return message;
 }

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
           return _normalizeMessage('Error en "$field": $msg', isLogin: isLogin);
         }
         return _normalizeMessage(msg, isLogin: isLogin);
       }
     }

     if (decoded.containsKey('msg')) {
       return _normalizeMessage(
         decoded['msg']?.toString() ?? 'Error desconocido',
         isLogin: isLogin,
       );
     }
   }

   if (resp.statusCode >= 500) {
     return 'El servidor no esta disponible en este momento. Intenta mas tarde.';
   }

   return 'No se pudo completar la solicitud.';
 }


 Future<String?> createUser(
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


   try {
     // Envia la peticion
     final resp = await http
         .post(
           url,
           headers: {'Content-Type': 'application/json'},
           body: json.encode(authData),
         )
         .timeout(const Duration(seconds: 15));

     if (resp.statusCode >= 400) {
       return _extractApiError(resp, isLogin: false);
     }

     final Map<String, dynamic> decodedResp = json.decode(resp.body);
     final ok = decodedResp['ok'] == true;

     if (!ok) {
       final msg = decodedResp['msg']?.toString() ?? 'No se pudo crear la cuenta.';
       return _normalizeMessage(msg, isLogin: false);
     }

     return null;
   } on TimeoutException {
     return 'La solicitud tardo demasiado. Revisa tu conexion e intenta nuevamente.';
   } on http.ClientException {
     return 'No fue posible conectar con el servidor. Revisa tu conexion.';
   } catch (_) {
     return 'Ocurrio un error inesperado al crear la cuenta.';
   }
 }
 Future<String?> login(String correo, String password) async {


   final Map<String, dynamic> authData = {
     'correo': correo,
     'password': password,
     //'returnSecureToken': true,
   };


   final url = Uri.https(_baseUrlLocal, '/api/auth/login', {
     //'key': _firebaseToken,
   });


   try {
     // Envia la peticion
     final resp = await http
         .post(
           url,
           headers: {'Content-Type': 'application/json'},
           body: json.encode(authData),
         )
         .timeout(const Duration(seconds: 15));

     if (resp.statusCode >= 400) {
       return _extractApiError(resp, isLogin: true);
     }

     // Decodifica la respuesta
     final Map<String, dynamic> decodedResp = json.decode(resp.body);
     final ok = decodedResp['ok'] == true;

     if (!ok) {
       final msg = decodedResp['msg']?.toString() ?? 'Credenciales invalidas.';
       return _normalizeMessage(msg, isLogin: true);
     }

     if (decodedResp.containsKey('token')) {
       // Token hay que guardarlo en un lugar seguro
       await storage.write(key: 'token', value: decodedResp['token']);
       return null;
     }

     return 'No se recibio un token valido del servidor.';
   } on TimeoutException {
     return 'La solicitud tardo demasiado. Revisa tu conexion e intenta nuevamente.';
   } on http.ClientException {
     return 'No fue posible conectar con el servidor. Revisa tu conexion.';
   } catch (_) {
     return 'Ocurrio un error inesperado al iniciar sesion.';
   }
  
 }


 Future logout() async {
   await storage.delete(key: 'token');
   return;
 }


 Future<String> readToken() async {
   return await storage.read(key: 'token') ?? '';
 }




}
