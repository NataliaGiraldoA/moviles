import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart';

// Manejador de mensajes en background (debe ser función de nivel superior)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Los mensajes en background con notificación los muestra automáticamente el SO
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await NotificationService.initialize();
  runApp(const ReminderApp());
}

class Reminder {
  Reminder({required this.text, this.done = false});

  final String text;
  bool done;
}

class ReminderApp extends StatelessWidget {
  const ReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recordatorios',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ReminderHomePage(),
    );
  }
}

class ReminderHomePage extends StatefulWidget {
  const ReminderHomePage({super.key});

  @override
  State<ReminderHomePage> createState() => _ReminderHomePageState();
}

class _ReminderHomePageState extends State<ReminderHomePage> {
  final List<Reminder> _reminders = <Reminder>[
    Reminder(text: 'Tomar agua'),
    Reminder(text: 'Revisar tareas de la universidad'),
    Reminder(text: 'Enviar avance del proyecto'),
  ];

  final TextEditingController _controller = TextEditingController();
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _cargarToken();
  }

  Future<void> _cargarToken() async {
    final String? token = await NotificationService.obtenerToken();
    setState(() => _fcmToken = token);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addReminder() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _reminders.insert(0, Reminder(text: text));
      _controller.clear();
    });

    // Disparar notificación push local al agregar un recordatorio
    await NotificationService.notificarNuevoRecordatorio(text);
  }

  void _toggleReminder(int index, bool? value) {
    setState(() {
      _reminders[index].done = value ?? false;
    });
  }

  void _mostrarToken() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Token FCM'),
        content: SelectableText(
          _fcmToken ?? 'Token no disponible',
          style: const TextStyle(fontSize: 12),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordatorios'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Ver token FCM',
            onPressed: _mostrarToken,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nuevo recordatorio',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addReminder(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _addReminder,
                  child: const Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _reminders.isEmpty
                  ? const Center(
                      child: Text('No hay recordatorios. Agrega uno nuevo.'),
                    )
                  : ListView.builder(
                      itemCount: _reminders.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Reminder reminder = _reminders[index];
                        return Card(
                          child: CheckboxListTile(
                            title: Text(
                              reminder.text,
                              style: TextStyle(
                                decoration: reminder.done
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            value: reminder.done,
                            onChanged: (bool? value) =>
                                _toggleReminder(index, value),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
