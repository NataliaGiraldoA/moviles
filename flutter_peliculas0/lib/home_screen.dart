import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //return Container();
    return Scaffold(
      appBar: AppBar(
        title: Text("Peliculas en cine"),
        elevation: 0,
      ),
      
      body: Center(
        child: Text("Home screen"),
      ),
      
      );
  }
}