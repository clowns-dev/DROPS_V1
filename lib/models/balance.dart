import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Balance {
  final int? idBalance;
  final String? balanceCode;
  final double? actuallyFactor; // Cambié a double?
  final int? available;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;
  final int? userID;

  Balance({
    this.idBalance,
    this.balanceCode,
    this.actuallyFactor, // Cambié a double?
    this.available,
    this.registerDate,
    this.lastUpdate,
    this.status,
    this.userID,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormatWithoutTime =
        DateFormat("yyyy-MM-dd"); // Para fechas sin hora
    DateFormat dateFormatWithTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss"); // Para fechas con hora

    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;

      try {
        return dateFormatWithTime.parse(dateString, true);
      } catch (e) {
        try {
          return dateFormatWithoutTime.parse(dateString);
        } catch (e) {
          if (kDebugMode) {
            print('Error al parsear la fecha: $dateString');
          }
          return null;
        }
      }
    }

    return Balance(
      idBalance: json['idBalance'],
      balanceCode: json['balanceCode'],
      actuallyFactor: json['actuallyFactor'] != null
          ? double.tryParse(json['actuallyFactor']
              .toString()) // Asegura que se convierte a double
          : null,
      available: json['available'],
      registerDate: parseDate(json['registerDate']),
      lastUpdate:
          json['lastUpdate'] != null && json['lastUpdate'] != "Sin Cambios"
              ? parseDate(json['lastUpdate'])
              : null,
      status: json['status'],
      userID: json['userID'],
    );
  }

  // Método adicional para calcular un "factor de tiempo operativo"
  double calculateOperationalFactor() {
    if (actuallyFactor == null) return 0.0;
    try {
      return actuallyFactor! *
          (status == 1 ? 1.1 : 0.9); // Ajuste basado en el estado
    } catch (e) {
      if (kDebugMode) {
        print('Error al parsear actuallyFactor: $actuallyFactor');
      }
      return 0.0;
    }
  }
}
