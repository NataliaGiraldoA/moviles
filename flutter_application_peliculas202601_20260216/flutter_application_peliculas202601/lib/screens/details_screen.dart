//stle

import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {

  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    //return Container();

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de Pelicula'),
        elevation: 0,
        backgroundColor: Colors.red,
      ),

      body: Center(
        child: Text('Details Screen')
      )


    );
  }
}