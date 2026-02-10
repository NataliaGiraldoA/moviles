//stle
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle de la pelicula"),
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      
      body: Center(
        child: Text("Detail screen"),
      ),
      
      );
  }
}