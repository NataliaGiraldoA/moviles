//import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

class UsuarioFormProvider extends ChangeNotifier {
  // ignore: unnecessary_new
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String correo = '';
  String password = '';
  String nombre = '';
  String img = '';
  String rol = 'USER_ROLE';
  //bool estado = true;
  bool google = false;

/*
"usuario": {
    "id": 8,
    "nombre": "Pedro Perez",
    "correo": "pedroperez@gmail.com",
    "password": "$2b$10$UA93jM6QMEJdwDf.Q8JTuO/1vX/4Lnelsa4VRf5qAsdxCR7kueCq.",
    "img": "pepito.jpg",
    "rol": "ADMIN_ROLE",
    "estado": true,
    "google": false,
    "fecha_creacion": "2025-09-29",
    "fecha_actualizacion": null
}
*/

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());

    print('$correo - $password - $nombre - $img - $rol - $google');

    return formKey.currentState?.validate() ?? false;
  }
}
