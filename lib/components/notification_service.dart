// lib/components/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Encapsula toda la lógica de notificaciones locales.
/// Se usa con métodos estáticos: NotificationService.init() / .show()
class NotificationService {
  // Instancia única del plugin (privada por el guion bajo).
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Inicializa el plugin y pide el permiso al usuario.
  /// Se llama una sola vez, al arrancar la app (en main).
  static Future<void> init() async {
    // Ícono que aparecerá en la barra de estado (usa el ícono de la app).
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _plugin.initialize(
      const InitializationSettings(android: androidSettings),
    );

    // Android 13+: el permiso POST_NOTIFICATIONS se pide en tiempo de
    // ejecución (no basta con declararlo en el manifiesto).
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Muestra una notificación con el título y el cuerpo recibidos.
  static Future<void> show({
    required String title,
    required String body,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        // Android 8+: toda notificación pertenece a un CANAL.
        // El usuario puede silenciar o configurar cada canal por separado.
        'covid_channel',               // id del canal
        'Datos COVID',                 // nombre visible para el usuario
        channelDescription: 'Resumen de datos de COVID-19',
        importance: Importance.high,   // aparece como "heads-up" con sonido
        priority: Priority.high,
        // Ejercicio de ampliación 3: texto expandido al desplegar.
        styleInformation: BigTextStyleInformation(body),
      ),
    );

    // El id 0 es fijo: cada notificación nueva reemplaza a la anterior.
    await _plugin.show(0, title, body, details);
  }
}