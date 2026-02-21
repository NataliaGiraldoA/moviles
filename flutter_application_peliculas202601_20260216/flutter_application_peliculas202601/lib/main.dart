//mateapp
import 'package:flutter/material.dart';

import 'screens/screens.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      //Quite el debug mode
      debugShowCheckedModeBanner: false,

      //Cambie el Titulo
      title: 'Peliculas App',

      //Defino el Screen Inicial
      initialRoute: 'home',

      //Defino las Rutas posibles de mi aplicacion
      routes: {
        'home': (_) => HomeScreen(),
        'detail': (_) => DetailsScreen(),
        'list': (_) => ListviewScreen(),
      },

      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
        )
      ),


      /*
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
      */
    );
  }
}

