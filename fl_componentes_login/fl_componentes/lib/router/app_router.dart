//import 'package:fl_componentes/models/menu_option.dart';
import 'package:flutter/material.dart';
import 'package:fl_componentes/screens/screens.dart';
import 'package:fl_componentes/models/models.dart';

class AppRoutes {
  //Se puede acceder sin necesidad de instanciar la clase
  static const initialRoute = 'login';

  static final menuOptions = <MenuOption>[
//    MenuOption(route: 'home', name: 'Home',screen: const HomeScreen(),icon: Icons.home, status:0),

    MenuOption(route: 'listview1', name: 'List View Tipo 1',screen: const Listview1Screen(),icon: Icons.list, ),
    MenuOption(route: 'listview2', name: 'List View Tipo 2',screen: const Listview2Screen(),icon: Icons.list_alt_outlined, ),
    MenuOption(route: 'alert', name: 'Alerta',screen: const AlertScreen(),icon: Icons.align_vertical_bottom, ),
    MenuOption(route: 'card', name: 'Tarjetas',screen: const CardScreen(),icon: Icons.credit_card,  ),
    MenuOption(route: 'prueba', name: 'Prueba',screen: const PruebaScreen(),icon: Icons.access_alarm, ),
    //MenuOption(route: 'login', name: 'Login',screen: const LoginScreen(),icon: Icons.login, ),
    //MenuOption(route: 'usuario', name: 'Usuario',screen: const UsuarioScreen(),icon: Icons.person, ),
  ];


  static Map<String, Widget Function(BuildContext)> getAppRoutes(){

    Map<String, Widget Function(BuildContext)> appRoutes = {};


    //Adicionar de forma manual las rutas que no se quieren ver en el menu
    appRoutes.addAll({ 'home' : ( BuildContext context ) => const HomeScreen() });
    appRoutes.addAll({ 'login' : ( BuildContext context ) => const LoginScreen() });
    appRoutes.addAll({ 'usuario' : ( BuildContext context ) => const UsuarioScreen() });

    for (final option in menuOptions){
      appRoutes.addAll({option.route: (BuildContext context) => option.screen});

    }

    return appRoutes;
  }

  /* 
  static Map<String, Widget Function(BuildContext)> routes = {
    'home': (BuildContext context) => const HomeScreen(),
    'alert': (BuildContext context) => const AlertScreen(),
    'card': (BuildContext context) => const CardScreen(),
    'listview1': (BuildContext context) => const Listview1Screen(),
    'listview2': (BuildContext context) => const Listview2Screen(),
  };
  */

  //static Route<dynamic>? Function(RouteSettings)? onGenerateRoute

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    //print(settings);

    return MaterialPageRoute(builder: (context) => const AlertScreen());
  }
}
