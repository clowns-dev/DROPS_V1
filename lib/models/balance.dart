import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Balance {
  final int? idBalance;
  final String? balanceCode;
  final String? actuallyFactor;
  final int? available;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;

  Balance({
    this.idBalance,
    this.balanceCode,
    this.actuallyFactor,
    this.available,
    this.registerDate,
    this.lastUpdate,
    this.status,
  });

  // Constructor fromJson con manejo de múltiples formatos de fecha
  factory Balance.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormatWithGMT = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    DateFormat dateFormatWithoutGMT = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime? parseDate(String? dateString) {
      if (dateString == null) return null;
      
      try {
        return dateFormatWithGMT.parse(dateString);
      } catch (e) {
        try {
          return dateFormatWithoutGMT.parse(dateString);
        } catch (e) {
          if (kDebugMode) {
            print('Error al parsear la fecha: $dateString');
          }
          return null; // Si ambos fallan, retornar null
        }
      }
    }

    return Balance(
      idBalance: json['idBalance'],
      balanceCode: json['balanceCode'],
      actuallyFactor: json['actuallyFactor'],
      available: json['available'],
      registerDate: parseDate(json['registerDate']),
      lastUpdate: json['lastUpdate'] != null && json['lastUpdate'] != "Sin Cambios"
                  ? parseDate(json['lastUpdate'])
                  : null,
      status: json['status'],
    );
  }
}
