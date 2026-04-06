import 'package:flutter/material.dart';

class HeroProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String nombre = '';
  String bio = '';
  String img = '';
  DateTime aparicion = DateTime.now();
  String casa = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());
    print('$nombre - $bio - $img - $aparicion - $casa');
    return formKey.currentState?.validate() ?? false;
  }
}
