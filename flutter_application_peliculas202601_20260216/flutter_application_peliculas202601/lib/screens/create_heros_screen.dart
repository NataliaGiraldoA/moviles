import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/services/services.dart';
import 'package:flutter_application_peliculas202601/ui/input_decorations.dart';
import 'package:flutter_application_peliculas202601/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_peliculas202601/providers/hero_provider.dart';

class CreateHerosScreen extends StatefulWidget {
  const CreateHerosScreen({super.key});

  @override
  State<CreateHerosScreen> createState() => _CreateHerosScreenState();
}

class _CreateHerosScreenState extends State<CreateHerosScreen> {
  static const Color _accentColor = Color(0xFFE040FB);

  final TextEditingController _nombreCtrl = TextEditingController();
  final TextEditingController _bioCtrl = TextEditingController();
  final TextEditingController _imgCtrl = TextEditingController();
  final TextEditingController _casaCtrl = TextEditingController();
  DateTime _aparicion = DateTime.now();

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _bioCtrl.dispose();
    _imgCtrl.dispose();
    _casaCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _aparicion,
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _accentColor,
              surface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null) {
      setState(() {
        _aparicion = selected;
      });
    }
  }

  String _formatDate(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final heroForm = Provider.of<HeroProvider>(context);
    final heroService = Provider.of<HeroService>(context, listen: false);

    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 180),
              CardContainer(
                child: Form(
                  key: heroForm.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const Text(
                        'NUEVO HEROE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Completa los datos del heroe',
                        style: TextStyle(color: Colors.white60),
                      ),
                      const SizedBox(height: 28),
                      TextFormField(
                        controller: _nombreCtrl,
                        decoration: InputDecorations.authInputDecoration(
                          hintText: 'Pedro Picapiedra',
                          labelText: 'Nombre',
                          prefixIcon: Icons.badge_outlined,
                        ),
                        onChanged: (value) => heroForm.nombre = value,
                        validator: (value) =>
                            (value != null && value.trim().length >= 3)
                            ? null
                            : 'Minimo 3 caracteres',
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _bioCtrl,
                        maxLines: 3,
                        decoration: InputDecorations.authInputDecoration(
                          hintText: 'Personaje de los Picapiedra',
                          labelText: 'Bio',
                          prefixIcon: Icons.notes_rounded,
                        ),
                        onChanged: (value) => heroForm.bio = value,
                        validator: (value) =>
                            (value != null && value.trim().length >= 6)
                            ? null
                            : 'Minimo 6 caracteres',
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _imgCtrl,
                        decoration: InputDecorations.authInputDecoration(
                          hintText: 'https://imagen.jpg',
                          labelText: 'Imagen URL',
                          prefixIcon: Icons.image_outlined,
                        ),
                        onChanged: (value) => heroForm.img = value,
                        validator: (value) =>
                            (value != null && value.trim().isNotEmpty)
                            ? null
                            : 'Ingresa una imagen',
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _casaCtrl,
                        decoration: InputDecorations.authInputDecoration(
                          hintText: 'Otra',
                          labelText: 'Casa',
                          prefixIcon: Icons.home_work_outlined,
                        ),
                        onChanged: (value) => heroForm.casa = value,
                        validator: (value) =>
                            (value != null && value.trim().isNotEmpty)
                            ? null
                            : 'Ingresa la casa',
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Aparicion',
                          style: TextStyle(color: Colors.white70),
                        ),
                        subtitle: Text(
                          _formatDate(_aparicion),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(
                            Icons.calendar_month_rounded,
                            color: _accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 52,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledColor: Colors.white24,
                        elevation: 0,
                        color: _accentColor,
                        child: Text(
                          heroForm.isLoading ? 'ESPERE' : 'GUARDAR HEROE',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.1,
                          ),
                        ),
                        onPressed: heroForm.isLoading
                            ? null
                            : () async {
                                FocusScope.of(context).unfocus();
                                if (!heroForm.isValidForm()) return;

                                heroForm.isLoading = true;
                                final errorMessage = await heroService
                                    .createHero(
                                      _nombreCtrl.text.trim(),
                                      _bioCtrl.text.trim(),
                                      _imgCtrl.text.trim(),
                                      _aparicion,
                                      _casaCtrl.text.trim(),
                                    );

                                if (!context.mounted) return;

                                if (errorMessage == null) {
                                  NotificationsService.showSnackbar(
                                    'Heroe creado correctamente',
                                  );
                                  Navigator.pop(context, true);
                                  return;
                                }

                                NotificationsService.showSnackbar(errorMessage);
                                heroForm.isLoading = false;
                              },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 34),
            ],
          ),
        ),
      ),
    );
  }
}
