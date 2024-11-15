import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Patient {
  ///Propiedades
  final int? idPatient;
  final String name;
  final String lastName;
  final String? secondLastName;
  final DateTime? birthDate;
  final String ci;
  final int? status;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? userID;

  ///Constructor
  Patient(
      {this.idPatient,
      required this.name,
      required this.lastName,
      this.secondLastName,
      required this.birthDate,
      required this.ci,
      this.status,
      this.registerDate,
      this.lastUpdate,
      this.userID});

  ///Mapeo a Json
  factory Patient.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormatWithoutTime =
        DateFormat("yyyy-MM-dd"); // Para fechas sin hora
    DateFormat dateFormatWithTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss"); // Para fechas con hora

    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;

      try {
        // Intentar con formato con hora
        return dateFormatWithTime.parse(dateString, true);
      } catch (e) {
        try {
          // Si no funciona, intentar con formato sin hora
          return dateFormatWithoutTime.parse(dateString);
        } catch (e) {
          if (kDebugMode) {
            print("Error al parsear la fecha: $dateString");
          }
          return null; // Si ambos intentos fallan, retornamos null
        }
      }
    }

    return Patient(
        idPatient: json['idPatient'],
        name: json['name'],
        lastName: json['lastName'],
        secondLastName: json['secondLastName'] ?? 'No tiene',
        birthDate:
            json['birthDate'] != null ? parseDate(json['birthDate']) : null,
        ci: json['ci'],
        status: json['status'],
        registerDate: parseDate(json['registerDate']),
        lastUpdate:
            json['lastUpdate'] != null && json['lastUpdate'] != "Sin Cambios"
                ? parseDate(json['lastUpdate'])
                : null,
        userID: json['userID']);
  }
}

class Balance {
  final int? idBalance;
  final String? balanceCode;
  final String? actuallyFactor;
  final int? available;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;
  final int? userID;

  Balance({
    this.idBalance,
    this.balanceCode,
    this.actuallyFactor,
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
        // Intentar con formato con hora
        return dateFormatWithTime.parse(dateString, true);
      } catch (e) {
        try {
          // Si no funciona, intentar con formato sin hora
          return dateFormatWithoutTime.parse(dateString);
        } catch (e) {
          if (kDebugMode) {
            print('Error al parsear la fecha: $dateString');
          }
          return null; // Si ambos intentos fallan, retornamos null
        }
      }
    }

    return Balance(
      idBalance: json['idBalance'],
      balanceCode: json['balanceCode'],
      actuallyFactor: json['actuallyFactor'],
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
      return double.parse(actuallyFactor!) *
          (status == 1 ? 1.1 : 0.9); // Ejemplo de ajuste basado en el estado
    } catch (e) {
      if (kDebugMode) {
        print('Error al parsear actuallyFactor: $actuallyFactor');
      }
      return 0.0;
    }
  }
}
