//mateapp
import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/providers/movie_provider.dart';
import 'package:flutter_application_peliculas202601/providers/ricky_morty_provider.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
 const AppState({super.key});


 @override
 Widget build(BuildContext context) {


   return MultiProvider(providers:[
     ChangeNotifierProvider(create: (_) => RickMortyProvider(), lazy: false,),
     ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false,),
   ],
   child: MyApp(),
   );
   //return const Placeholder();
 }
}


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

