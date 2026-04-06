import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/providers/user_form_provider.dart';
import 'package:provider/provider.dart';


import 'package:flutter_application_peliculas202601/ui/input_decorations.dart';
import 'package:flutter_application_peliculas202601/widgets/widgets.dart';


import 'package:flutter_application_peliculas202601/services/services.dart';


class UsuarioScreen extends StatelessWidget {
 const UsuarioScreen({super.key});

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
                     'SIGN UP',
                     style: TextStyle(
                       color: Colors.white,
                       fontSize: 24,
                       fontWeight: FontWeight.w900,
                       letterSpacing: 2,
                     ),
                   ),
                   const SizedBox( height: 6 ),
                   Text(
                     'Crea tu cuenta',
                     style: TextStyle(
                       color: Colors.white.withValues(alpha: 0.65),
                       fontSize: 13,
                     ),
                   ),
                   const SizedBox( height: 30 ),
                  
                   ChangeNotifierProvider(
                     create: ( _ ) => UserFormProvider(),
                     child: _UserForm()
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
               onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
               style: ButtonStyle(
                 overlayColor: WidgetStateProperty.all( _accentColor.withValues(alpha: 0.12)),
                 foregroundColor: WidgetStateProperty.all(_accentColor),
                 shape: WidgetStateProperty.all(const StadiumBorder())
               ),
               child: const Text(
                 'Ya tienes cuenta? Inicia sesion',
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




class _UserForm extends StatelessWidget {

 static const Color _accentColor = Color(0xFFE040FB);



 @override
 Widget build(BuildContext context) {


   final userForm = Provider.of<UserFormProvider>(context);

   return Form(
       key: userForm.formKey,
       autovalidateMode: AutovalidateMode.onUserInteraction,


       child: Column(
         children: [

          TextFormField(
             autocorrect: false,
             keyboardType: TextInputType.name,
             decoration: InputDecorations.authInputDecoration(
               hintText: 'Jhon Doe',
               labelText: 'Nombre completo',
               prefixIcon: Icons.person_outline
             ),
             onChanged: ( value ) => userForm.nombre = value
           ),

           const SizedBox( height: 24 ),
          
           TextFormField(
             autocorrect: false,
             keyboardType: TextInputType.emailAddress,
             decoration: InputDecorations.authInputDecoration(
               hintText: 'john.doe@gmail.com',
               labelText: 'Correo electrónico',
               prefixIcon: Icons.alternate_email_rounded
             ),
             onChanged: ( value ) => userForm.correo = value,
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
             onChanged: ( value ) => userForm.password = value,
             validator: ( value ) {


                 return ( value != null && value.length >= 6 )
                   ? null
                   : 'La contraseña debe de ser de 6 caracteres';                                   
                
             },
           ),

           TextFormField(
             autocorrect: false,
             keyboardType: TextInputType.emailAddress,
             decoration: InputDecorations.authInputDecoration(
               hintText: 'https://foto.jpg',
               labelText: 'Foto de perfil',
               prefixIcon: Icons.image_outlined
             ),
             onChanged: ( value ) => userForm.img = value,
             validator: ( value ) {


                 return ( value != null && value.length >= 3 )
                   ? null
                   : 'La URL de la foto debe de tener al menos 3 caracteres';                                   
                
             },
           ),
           SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'USER_ROLE o ADMIN_ROLE',
                labelText: 'Rol',
                prefixIcon: Icons.supervised_user_circle_outlined,
              ),
              onChanged: (value) => userForm.rol = value,
              validator: (value) {
                return (value != null &&
                        (value == 'USER_ROLE' || value == 'ADMIN_ROLE'))
                    ? null
                    : 'El rol debe ser USER_ROLE o ADMIN_ROLE';
              },
            ),
            SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'true o false',
                labelText: 'Google',
                prefixIcon: Icons.account_circle_outlined,
              ),
              onChanged: (value) =>
                  userForm.google = (value.toLowerCase() == 'true'),
              validator: (value) {
                return (value != null &&
                        (value.toLowerCase() == 'true' ||
                            value.toLowerCase() == 'false'))
                    ? null
                    : 'El valor debe ser true o false';
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
               userForm.isLoading
                 ? 'ESPERE'
                 : 'CREAR CUENTA',
               style: const TextStyle(
                 color: Colors.white,
                 fontWeight: FontWeight.w800,
                 letterSpacing: 1.1,
               ),
             ),
             onPressed: userForm.isLoading ? null : () async {
              
               FocusScope.of(context).unfocus();
               final authService = Provider.of<AuthService>(context, listen: false);
              


               if( !userForm.isValidForm() ) return;


               userForm.isLoading = true;

               final String? errorMessage = await authService
                          .createUser(
                            userForm.correo,
                            userForm.password,
                            userForm.nombre,
                            userForm.img,
                            userForm.rol,
                            userForm.google

                          );

               if (!context.mounted) return;

               if ( errorMessage == null ) {
                 Navigator.pushReplacementNamed(context, 'home');
               } else {
                 NotificationsService.showSnackbar(errorMessage);
                 userForm.isLoading = false;
               }


               //userForm.isLoading = false;


               //loginForm.validarLogin();


               //Navigator.pushReplacementNamed(context, 'home');
             }
           )


         ],
       ),
     );

 }
}
