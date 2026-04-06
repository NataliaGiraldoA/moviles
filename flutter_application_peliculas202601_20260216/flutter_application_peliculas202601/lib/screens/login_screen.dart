//fls
//Snipped de flutter screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import 'package:flutter_application_peliculas202601/providers/login_form_provider.dart';
import 'package:flutter_application_peliculas202601/ui/input_decorations.dart';
import 'package:flutter_application_peliculas202601/widgets/widgets.dart';


import 'package:flutter_application_peliculas202601/services/services.dart';


//import 'package:productos_app/ui/input_decorations.dart';




class LoginScreen extends StatelessWidget {
 const LoginScreen({super.key});

 static const Color _accentColor = Color(0xFFE040FB);


 @override
 Widget build(BuildContext context) {
   return Scaffold(
     //appBar: AppBar(title: const Text('Screen de Login')),


     //body: Center(child: Text('LoginScreen')),






     body: AuthBackground(
      
       /*
       child:Container(
         width: double.infinity,
         height: 300,
         color: Colors.red,


       )
       */
     
      
       child: SingleChildScrollView(


         child: Column(
           children: [


             const SizedBox( height: 220 ),


             CardContainer(


               child: Column(
                 children: [


                   const SizedBox( height: 10 ),
                   const Text(
                     'LOGIN',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 24,
                       fontWeight: FontWeight.w900,
                       letterSpacing: 2,
                     ),
                   ),
                   const SizedBox( height: 6 ),
                   Text(
                     'Bienvenida de nuevo',
                     style: TextStyle(
                       color: Colors.white.withValues(alpha: 0.65),
                       fontSize: 13,
                     ),
                   ),
                   const SizedBox( height: 30 ),
                  
                   ChangeNotifierProvider(
                     create: ( _ ) => LoginFormProvider(),
                     child: _LoginForm()
                   )
                  


                 ],
               )




             ),


             /*
             SizedBox( height: 50 ),
             Text('Crear una nueva cuenta', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold ),),
             SizedBox( height: 50 ),
             */
            
             const SizedBox( height: 24 ),
             TextButton(
               onPressed: () => Navigator.pushReplacementNamed(context, 'usuario'),
               style: ButtonStyle(
                 overlayColor: WidgetStateProperty.all( _accentColor.withValues(alpha: 0.12)),
                 foregroundColor: WidgetStateProperty.all(_accentColor),
                 shape: WidgetStateProperty.all(const StadiumBorder())
               ),
               child: const Text(
                 'Crear una nueva cuenta',
                 style: TextStyle(
                   fontSize: 15,
                   fontWeight: FontWeight.w700,
                   letterSpacing: 0.8,
                 ),
               )
             ),
             const SizedBox( height: 40 ),


           ],
         ),
       )
      
     )
  


   );
  
 }
}




class _LoginForm extends StatelessWidget {

 static const Color _accentColor = Color(0xFFE040FB);



 @override
 Widget build(BuildContext context) {


   final loginForm = Provider.of<LoginFormProvider>(context);


   return Form(
       key: loginForm.formKey,
       autovalidateMode: AutovalidateMode.onUserInteraction,


       child: Column(
         children: [
          
           TextFormField(
             autocorrect: false,
             keyboardType: TextInputType.emailAddress,
             decoration: InputDecorations.authInputDecoration(
               hintText: 'john.doe@gmail.com',
               labelText: 'Correo electrónico',
               prefixIcon: Icons.alternate_email_rounded
             ),
             onChanged: ( value ) => loginForm.correo = value,
             validator: ( value ) {


                 String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                 RegExp regExp  = RegExp(pattern);
                
                 return regExp.hasMatch(value ?? '')
                   ? null
                   : 'El valor ingresado no luce como un correo';


             },
           ),


           const SizedBox( height: 24 ),


           TextFormField(
             autocorrect: false,
             obscureText: true,
             keyboardType: TextInputType.emailAddress,
             decoration: InputDecorations.authInputDecoration(
               hintText: '*****',
               labelText: 'Contraseña',
               prefixIcon: Icons.lock_outline
             ),
             onChanged: ( value ) => loginForm.password = value,
             validator: ( value ) {


                 return ( value != null && value.length >= 6 )
                   ? null
                   : 'La contraseña debe de ser de 6 caracteres';                                   
                
             },
           ),


           const SizedBox( height: 30 ),


           MaterialButton(
             minWidth: double.infinity,
             height: 52,
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
             disabledColor: Colors.white24,
             elevation: 0,
             color: _accentColor,




             // ignore: sort_child_properties_last
             child: Text(
               loginForm.isLoading
                 ? 'ESPERE'
                 : 'INGRESAR',
               style: const TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.w800,
                 letterSpacing: 1.1,
               ),
             ),
             onPressed: loginForm.isLoading ? null : () async {
              
               FocusScope.of(context).unfocus();
               final authService = Provider.of<AuthService>(context, listen: false);
              


               if( !loginForm.isValidForm() ) return;


               //loginForm.isLoading = true;


               //await Future.delayed(Duration(seconds: 2 ));


               // TODO: validar si el login es correcto
               final String? errorMessage = await authService.login(loginForm.correo, loginForm.password);

               if (!context.mounted) return;


               if ( errorMessage == null ) {
                 Navigator.pushReplacementNamed(context, 'home');
               } else {
                 // TODO: mostrar error en pantalla
                 //print( errorMessage );
                
                 NotificationsService.showSnackbar(errorMessage);
                 loginForm.isLoading = false;
               }


               //loginForm.isLoading = false;


               //loginForm.validarLogin();


               //Navigator.pushReplacementNamed(context, 'home');
             }
           )


         ],
       ),
     );
 }
}




