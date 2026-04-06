import 'package:flutter/material.dart';
import 'package:flutter_application_peliculas202601/models/models.dart';
import 'package:flutter_application_peliculas202601/services/services.dart';
import 'package:provider/provider.dart';

class HeroesScreen extends StatefulWidget {
  const HeroesScreen({super.key});

  @override
  State<HeroesScreen> createState() => _HeroesScreenState();
}

class _HeroesScreenState extends State<HeroesScreen> {
  static const Color _accentColor = Color(0xFFE040FB);
  late Future<List<HeroModel>> _heroesFuture;

  @override
  void initState() {
    super.initState();
    _reloadHeroes();
  }

  void _reloadHeroes() {
    final heroService = Provider.of<HeroService>(context, listen: false);
    _heroesFuture = heroService.fetchHeroes();
  }

  Future<void> _openCreateHero() async {
    final created = await Navigator.pushNamed(context, 'createHero');
    if (created == true && mounted) {
      setState(_reloadHeroes);
    }
  }

  Future<void> _openEditHero(HeroModel hero) async {
    final updated = await Navigator.pushNamed(
      context,
      'editHero',
      arguments: hero,
    );
    if (updated == true && mounted) {
      setState(_reloadHeroes);
    }
  }

  Future<void> _deleteHero(HeroModel hero) async {
    if (hero.id == null || hero.id!.isEmpty) {
      NotificationsService.showSnackbar('No se encontro el id del heroe.');
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Eliminar heroe',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Seguro que deseas eliminar a ${hero.nombre}?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    final heroService = Provider.of<HeroService>(context, listen: false);
    final errorMessage = await heroService.deleteHero(hero.id!);

    if (errorMessage == null) {
      NotificationsService.showSnackbar('Heroe eliminado');
      if (mounted) {
        setState(_reloadHeroes);
      }
      return;
    }

    NotificationsService.showSnackbar(errorMessage);
  }

  String _formatDate(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD HEROES')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateHero,
        backgroundColor: _accentColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<HeroModel>>(
        future: _heroesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          }

          final heroes = snapshot.data ?? [];
          if (heroes.isEmpty) {
            return const Center(
              child: Text(
                'No hay heroes registrados',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            color: _accentColor,
            onRefresh: () async {
              setState(_reloadHeroes);
              await _heroesFuture;
            },
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              itemCount: heroes.length,
              itemBuilder: (_, i) {
                final hero = heroes[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF1A1A2E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: _accentColor.withValues(alpha: 0.22),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _accentColor.withValues(alpha: 0.2),
                      foregroundColor: _accentColor,
                      child: Text(
                        hero.nombre.isNotEmpty
                            ? hero.nombre[0].toUpperCase()
                            : '?',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                    title: Text(
                      hero.nombre,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '${hero.casa}  •  ${_formatDate(hero.aparicion)}',
                      style: const TextStyle(color: Colors.white60),
                    ),
                    onTap: () => _openEditHero(hero),
                    trailing: Wrap(
                      spacing: 0,
                      children: [
                        IconButton(
                          onPressed: () => _openEditHero(hero),
                          icon: const Icon(
                            Icons.edit_rounded,
                            color: _accentColor,
                          ),
                        ),
                        IconButton(
                          onPressed: () => _deleteHero(hero),
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
