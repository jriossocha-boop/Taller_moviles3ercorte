// lib/components/covid_data.dart

/// Modelo de datos: representa la respuesta de la API para un país.
/// Separar el modelo de la interfaz permite reutilizarlo y probarlo fácilmente.
class CovidData {
  final String country;      // Nombre del país
  final int cases;           // Casos acumulados
  final int todayCases;      // Casos del día
  final int deaths;          // Muertes acumuladas
  final int todayDeaths;     // Muertes del día
  final int recovered;       // Recuperados acumulados
  final DateTime updated;    // Fecha de actualización
  final String flag;         // URL de la bandera (ejercicio de ampliación 1)

  CovidData({
    required this.country,
    required this.cases,
    required this.todayCases,
    required this.deaths,
    required this.todayDeaths,
    required this.recovered,
    required this.updated,
    required this.flag,
  });

  /// Constructor de fábrica: transforma el JSON (Map) en un objeto CovidData.
  factory CovidData.fromJson(Map<String, dynamic> json) {
    // Convierte cualquier valor numérico a int. Se usa `num?` porque el JSON
    // puede traer enteros o decimales, y porque el campo puede venir ausente
    // (null). Si falta, devolvemos 0 en lugar de que la app se rompa.
    int toInt(dynamic v) => (v as num?)?.toInt() ?? 0;

    // La bandera viene anidada: { "countryInfo": { "flag": "https://..." } }
    final info = json['countryInfo'] as Map<String, dynamic>?;

    return CovidData(
      country: json['country'] as String,
      cases: toInt(json['cases']),
      todayCases: toInt(json['todayCases']),
      deaths: toInt(json['deaths']),
      todayDeaths: toInt(json['todayDeaths']),
      recovered: toInt(json['recovered']),
      // La API entrega la fecha en milisegundos desde 1970 (epoch).
      updated: DateTime.fromMillisecondsSinceEpoch(toInt(json['updated'])),
      flag: (info?['flag'] as String?) ?? '',
    );
  }
}