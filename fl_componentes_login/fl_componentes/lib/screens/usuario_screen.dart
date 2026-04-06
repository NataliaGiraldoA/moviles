import 'package:fl_componentes/providers/usuario_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fl_componentes/ui/input_decorations.dart';
import 'package:fl_componentes/widgets/widgets.dart';

import 'package:fl_componentes/services/services.dart';

class UsuarioScreen extends StatelessWidget {
  const UsuarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Screen de usuario')),

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
              SizedBox(height: 250),

              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Crear Usuario',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(height: 30),

                    ChangeNotifierProvider(
                      create: (_) => UsuarioFormProvider(),
                      child: _UsuarioForm(),
                    ),
                  ],
                ),
              ),

              /*
              SizedBox( height: 50 ),
              Text('Ir al login', style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold ),),
              SizedBox( height: 50 ),
              */
              SizedBox(height: 50),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.indigo),
                  shape: WidgetStateProperty.all(StadiumBorder()),
                ),
                child: Text(
                  '¿Ya tienes una cuenta?',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsuarioForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final usuarioForm = Provider.of<UsuarioFormProvider>(context);

    return Container(
      child: Form(
        key: usuarioForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'John Doe',
                labelText: 'Nombre completo',
                prefixIcon: Icons.person,
              ),
              onChanged: (value) => usuarioForm.nombre = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'El nombre debe de ser de 3 caracteres';
              },
            ),

            SizedBox(height: 30),

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'john.doe@gmail.com',
                labelText: 'Correo electrónico',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              onChanged: (value) => usuarioForm.correo = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);

                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El valor ingresado no luce como un correo';
              },
            ),

            SizedBox(height: 30),

            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value) => usuarioForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe de ser de 6 caracteres';
              },
            ),

            SizedBox(height: 30),

            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'https://foto.jpg',
                labelText: 'Foto URL',
                prefixIcon: Icons.image_outlined,
              ),
              onChanged: (value) => usuarioForm.img = value,
              validator: (value) {
                return (value != null && value.length >= 3)
                    ? null
                    : 'La URL debe de ser de 3 caracteres';
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
              onChanged: (value) => usuarioForm.rol = value,
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
                  usuarioForm.google = (value.toLowerCase() == 'true'),
              validator: (value) {
                return (value != null &&
                        (value.toLowerCase() == 'true' ||
                            value.toLowerCase() == 'false'))
                    ? null
                    : 'El valor debe ser true o false';
              },
            ),
            SizedBox(height: 30),

            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,

              // ignore: sort_child_properties_last
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  usuarioForm.isLoading ? 'Espere' : 'Ingresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: usuarioForm.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      final authService = Provider.of<AuthService>(
                        context,
                        listen: false,
                      );

                      if (!usuarioForm.isValidForm()) return;

                      usuarioForm.isLoading = true;

                      // TODO: validar si el login es correcto
                      final String? errorMessage = await authService
                          .createUserLocal(
                            usuarioForm.correo,
                            usuarioForm.password,
                            usuarioForm.nombre,
                            usuarioForm.img,
                            usuarioForm.rol,
                            usuarioForm.google,
                          );

                      if (errorMessage == null) {
                        NotificationsService.showSnackbar('Usuario CREADO');

                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        // TODO: mostrar error en pantalla
                        print(errorMessage);

                        NotificationsService.showSnackbar(errorMessage);
                        usuarioForm.isLoading = false;
                      }

                      //await Future.delayed(Duration(seconds: 2));

                      // TODO: validar si el usuario es correcto
                      //usuarioForm.isLoading = false;

                      //usuarioForm.validarusuario();

                      //Navigator.pushReplacementNamed(context, 'home');
                    },
            ),
          ],
        ),
      ),
    );
  }
}
