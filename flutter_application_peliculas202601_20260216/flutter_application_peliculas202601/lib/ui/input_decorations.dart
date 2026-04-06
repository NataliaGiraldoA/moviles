import 'package:flutter/material.dart';


class InputDecorations {

  static const Color _accentColor = Color(0xFFE040FB);

  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon
  }) {
    return InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white24
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: _accentColor,
            width: 2
          )
        ),
        hintStyle: const TextStyle(color: Colors.white38),
        floatingLabelStyle: const TextStyle(color: _accentColor),
        hintText: hintText,
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Colors.white60
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF6E6E)),
        prefixIcon: prefixIcon != null 
          ? Icon( prefixIcon, color: _accentColor )
          : null
      );
  }  

}