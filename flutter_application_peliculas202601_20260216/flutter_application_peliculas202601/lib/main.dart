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

      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFE040FB),
          secondary: const Color(0xFFE040FB),
          surface: const Color(0xFF1A1A2E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A2E),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
          iconTheme: IconThemeData(color: Color(0xFFE040FB)),
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFFE040FB),
        ),
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

