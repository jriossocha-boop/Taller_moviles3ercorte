// lib/components/covid_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'covid_data.dart';

/// Formatea un número con separador de miles: 6300000 -> "6.300.000".
/// Se expone como función pública para reutilizarla en la notificación.
String formatNumber(int n) => NumberFormat.decimalPattern('es_CO').format(n);

/// Formatea la fecha como dd/MM/aaaa HH:mm.
String formatDate(DateTime d) => DateFormat('dd/MM/yyyy HH:mm').format(d);

/// Tarjeta reutilizable que muestra los datos de un país.
/// Es un StatelessWidget: solo dibuja lo que recibe, no guarda estado.
class CovidCard extends StatelessWidget {
  final CovidData data;

  const CovidCard({super.key, required this.data});

  /// Fila "etiqueta ........ valor".
  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Bandera (si la API la entrega)
            if (data.flag.isNotEmpty)
              Center(
                child: Image.network(
                  data.flag,
                  height: 80,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.flag, size: 48),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              data.country,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Divider(height: 24),
            _row('Casos acumulados', formatNumber(data.cases)),
            _row('Casos del día', formatNumber(data.todayCases)),
            _row('Muertes acumuladas', formatNumber(data.deaths)),
            _row('Muertes del día', formatNumber(data.todayDeaths)),
            _row('Recuperados', formatNumber(data.recovered)),
            _row('Actualizado', formatDate(data.updated)),
          ],
        ),
      ),
    );
  }
}