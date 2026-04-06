import 'package:fl_componentes/providers/ricky_morty_provider.dart';
import 'package:fl_componentes/router/app_router.dart';
import 'package:fl_componentes/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/services.dart';
//import 'package:fl_componentes/screens/screens.dart';

//void main() => runApp(const MyApp());
void main() => runApp( AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (_) => RickMortyProvider(), lazy: false,),
        ChangeNotifierProvider(create: ( _ ) => AuthService() ),      
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

      //Ojo para los mensajes 
      scaffoldMessengerKey: NotificationsService.messengerKey,

      debugShowCheckedModeBanner: false,

      title: 'Material App',

      //home: HomeScreen()

      //initialRoute: 'home',
      initialRoute: AppRoutes.initialRoute,

      /*
      routes: {
        'home': (BuildContext context) => const HomeScreen(),
        'alert': (BuildContext context) => const AlertScreen(),
        'card': (BuildContext context) => const CardScreen(),
        'listview1': (BuildContext context) => const Listview1Screen(),
        'listview2': (BuildContext context) => const Listview2Screen(),
      },
      */
      routes: AppRoutes.getAppRoutes(),

      /*
      onGenerateRoute: (settings) {
        //print(settings);

        return MaterialPageRoute(builder: (context) => const AlertScreen());
      },
      */
      onGenerateRoute: AppRoutes.onGenerateRoute,

      //theme: ThemeData.light(),
      
      /*
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.indigo,

        //appBar Theme
        appBarTheme: AppBarTheme(backgroundColor: Colors.green, elevation: 2),
      ),
      */

      theme: AppTheme.lightTheme,

      //theme: ThemeData.light().copyWith(
      //  scaffoldBackgroundColor: Colors.grey[300]
      //),




      /*
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hola Mundo...'),
        ),
      ),
      */
    );
  }
}
