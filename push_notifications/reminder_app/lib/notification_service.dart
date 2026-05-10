import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Canal de notificaciones para Android 8+
const AndroidNotificationChannel androidChannel = AndroidNotificationChannel(
  'recordatorios_channel',
  'Recordatorios',
  description: 'Notificaciones de la app de recordatorios',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin localNotifications =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static Future<void> initialize() async {
    // Configurar flutter_local_notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await localNotifications.initialize(initSettings);

    // Crear el canal en Android
    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Solicitar permisos de FCM (iOS + Android 13+)
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Mensajes en primer plano: mostrar notificación local
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _mostrarNotificacionLocal(
        titulo: message.notification?.title ?? 'Recordatorio',
        cuerpo: message.notification?.body ?? '',
      );
    });

    // Cuando el usuario toca la notificación con la app en background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Aquí puedes navegar a una pantalla específica si lo necesitas
    });
  }

  // Muestra el token FCM en consola para pruebas desde Firebase Console
  static Future<String?> obtenerToken() async {
    final String? token = await FirebaseMessaging.instance.getToken();
    // ignore: avoid_print
    print('FCM Token: $token');
    return token;
  }

  // Notificación local inmediata (se usa al agregar un recordatorio)
  static Future<void> _mostrarNotificacionLocal({
    required String titulo,
    required String cuerpo,
  }) async {
    await localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      titulo,
      cuerpo,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidChannel.id,
          androidChannel.name,
          channelDescription: androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
  }

  // Llamar desde la UI al agregar un nuevo recordatorio
  static Future<void> notificarNuevoRecordatorio(String texto) async {
    await _mostrarNotificacionLocal(
      titulo: 'Nuevo recordatorio',
      cuerpo: texto,
    );
  }
}
