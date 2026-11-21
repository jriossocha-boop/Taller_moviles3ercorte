// lib/main.dart

import 'package:flutter/material.dart';
import 'components/covid_api.dart';
import 'components/covid_card.dart';
import 'components/covid_data.dart';
import 'components/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();

  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista de respaldo: se usa mientras carga la lista real o si falla.
  List<String> countries = [
    'Colombia',
    'Mexico',
    'Argentina',
    'Peru',
    'Chile',
    'Spain',
    'USA',
  ];

  String selected = 'Colombia';

  late Future<CovidData> future = fetchCountry(selected);

  @override
  void initState() {
    super.initState();
    _loadCountries(); // Ejercicio 2: cargar países desde la API
  }

  /// Carga la lista completa de países. Si falla (sin internet, etc.),
  /// se conserva la lista de respaldo y la app sigue funcionando.
  Future<void> _loadCountries() async {
    try {
      final names = await fetchCountryNames();
      // `mounted` evita llamar setState si la pantalla ya fue cerrada.
      if (!mounted || names.isEmpty) return;
      setState(() {
        countries = names;
        // El dropdown exige que el valor seleccionado exista en la lista.
        if (!countries.contains(selected)) {
          selected = countries.first;
          future = fetchCountry(selected);
        }
      });
    } catch (_) {
      // Silencioso a propósito: se queda con la lista de respaldo.
    }
  }

  void _reload() {
    setState(() {
      future = fetchCountry(selected);
    });
  }

  /// Envía la notificación con los números ya formateados.
  Future<void> _notify(CovidData d) async {
    await NotificationService.show(
      title: 'COVID-19: ${d.country}',
      body: 'Casos: ${formatNumber(d.cases)} | '
          'Muertes: ${formatNumber(d.deaths)} | '
          'Hoy: ${formatNumber(d.todayCases)}',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Datos COVID-19')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- Selector de país ----------
            DropdownButton<String>(
              value: selected,
              isExpanded: true,
              items: countries
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                selected = value;
                _reload();
              },
            ),
            const SizedBox(height: 16),

            // ---------- Zona de datos ----------
            Expanded(
              child: FutureBuilder<CovidData>(
                future: future,
                builder: (context, snapshot) {
                  // 1) Cargando
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2) Error
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No se pudo consultar: ${snapshot.error}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _reload,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    );
                  }

                  // 3) Datos: tarjeta + botón. El scroll evita desbordes
                  // en pantallas pequeñas.
                  final d = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: CovidCard(data: d),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => _notify(d),
                        child: const Text('Enviar notificación'),
                      ),
                    ],
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