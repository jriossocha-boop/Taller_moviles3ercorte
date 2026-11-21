# Taller 3er Corte: API COVID-19 y notificaciones locales (Flutter)

Aplicación Flutter para Android que consulta la API pública
[disease.sh](https://disease.sh), muestra las estadísticas de COVID-19 de un
país elegido y envía una notificación local con el resumen.

> **Nota sobre los datos:** las cifras de COVID ya no se actualizan como antes.
> El taller trata sobre el consumo de APIs, no sobre cifras actuales.

## Funcionalidades

- Consulta HTTP a `https://disease.sh/v3/covid-19/countries/<país>`.
- Conversión del JSON a un modelo tipado de Dart (`CovidData`).
- Selector de país cargado desde la API (con lista de respaldo si falla).
- Bandera del país, números con separador de miles y fecha legible (`intl`).
- Estados de carga y de error, con botón **Reintentar**.
- Notificación local con texto expandido y permiso en tiempo de ejecución
  (Android 13+).

## Estructura del proyecto

```
lib/
├── components/
│   ├── covid_api.dart             # Peticiones HTTP (país y lista de países)
│   ├── covid_card.dart            # Tarjeta reutilizable + formato de datos
│   ├── covid_data.dart            # Modelo y fromJson
│   └── notification_service.dart  # Notificaciones locales
└── main.dart                      # Interfaz principal
```

## Requisitos

- Flutter SDK 3.22 o superior (`flutter doctor` sin errores de Android)
- Android Studio o VS Code con extensiones de Flutter y Dart
- Emulador Android (API 33 o superior) o teléfono con depuración USB
- Conexión a internet

## Dependencias

| Paquete | Versión | Uso |
|---|---|---|
| `http` | ^1.2.0 | Peticiones a la API |
| `flutter_local_notifications` | ^19.0.0 | Notificaciones locales |
| `intl` | la que instale `flutter pub add intl` | Formato de fechas y números |

> No actualizar `flutter_local_notifications` a una versión mayor que la 19:
> cambia la API y el código de `notification_service.dart` dejaría de compilar.

## Configuración de Android

- `AndroidManifest.xml`: permisos `INTERNET` y `POST_NOTIFICATIONS`.
- `android/app/build.gradle.kts`: `isCoreLibraryDesugaringEnabled = true` y
  `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")`.

## Ejecución

```bash
git clone https://github.com/jriossocha-boop/Taller_moviles3ercorte.git

cd taller_3ercorte
flutter pub get
flutter run
```

## Generar el APK (opcional)

```bash
flutter build apk --release
```

El archivo queda en `build/app/outputs/flutter-apk/app-release.apk`.

## Pruebas realizadas

1. Al abrir la app se solicita el permiso de notificaciones.
2. Al cambiar de país se actualizan los datos y la bandera.
3. El botón **Enviar notificación** muestra el resumen en la barra superior.
4. Con el modo avión activo aparece el error y **Reintentar** lo recupera.

## Ejercicios de ampliación realizados

- [x] 1. Bandera del país (`countryInfo.flag`)
- [x] 2. Lista de países cargada desde la API
- [x] 3. Notificación expandida (`BigTextStyleInformation`)
- [ ] 4. Consulta periódica con `workmanager` (no realizado)
- [x] 5. Interfaz separada en widgets (`CovidCard`)
- [x] 6. Formato con `intl`

## Autor

Nombre del estudiante: _______________
Curso: Desarrollo de aplicaciones móviles, tercer corte
