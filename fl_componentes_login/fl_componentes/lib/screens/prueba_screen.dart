import 'package:flutter/material.dart';

class PruebaScreen extends StatelessWidget {
   
  const PruebaScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Screen de Prueba')),
      body: Center(
         child: Text('PruebaScreen'),
      ),
    );
  }
}