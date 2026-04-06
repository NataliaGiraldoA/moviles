import 'package:flutter/material.dart';

class UserFormProvider extends ChangeNotifier {
 
  // ignore: unnecessary_new
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String nombre = '';
  String correo = '';
  String password = '';
  String img = '';
  String rol = 'USER_ROLE';
  //bool estado = true;
  bool google = false;


  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //set nombre(String nombre) {}

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