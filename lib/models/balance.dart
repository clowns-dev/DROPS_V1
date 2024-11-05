import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Balance {
  final int? idBalance;
  final String? balanceCode;
  final String? factor;
  final int? available;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;
  final int? userID;

  Balance({
    this.idBalance,
    this.balanceCode,
    this.factor,
    this.available,
    this.registerDate,
    this.lastUpdate,
    this.status,
    this.userID
  });

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
          return null;
        }
      }
    }

    return Balance(
      idBalance: json['idBalance'],
      balanceCode: json['balanceCode'],
      factor: json['factor'],
      available: json['available'],
      registerDate: parseDate(json['registerDate']),
      lastUpdate: json['lastUpdate'] != null && json['lastUpdate'] != "Sin Cambios"
                  ? parseDate(json['lastUpdate'])
                  : null,
      status: json['status'],
      userID: json['userID']
    );
  }
}
