// lib/components/covid_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'covid_data.dart';

/// Consulta los datos de COVID de un solo país.
Future<CovidData> fetchCountry(String country) async {
  final uri = Uri.https(
    'disease.sh',
    '/v3/covid-19/countries/${Uri.encodeComponent(country)}',
  );

  final response = await http.get(uri).timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception('Error del servidor: ${response.statusCode}');
  }

  return CovidData.fromJson(
    jsonDecode(response.body) as Map<String, dynamic>,
  );
}

/// Ejercicio 2: obtiene la lista de nombres de todos los países.
/// La API devuelve una LISTA de objetos (no un Map), por eso se decodifica
/// como List y de cada elemento solo se toma el campo "country".
Future<List<String>> fetchCountryNames() async {
  final uri = Uri.https('disease.sh', '/v3/covid-19/countries');

  final response = await http.get(uri).timeout(const Duration(seconds: 15));

  if (response.statusCode != 200) {
    throw Exception('Error del servidor: ${response.statusCode}');
  }

  final list = jsonDecode(response.body) as List<dynamic>;

  final names = list
      .map((item) => (item as Map<String, dynamic>)['country'] as String)
      .toList();

  names.sort(); // orden alfabético
  return names;
}