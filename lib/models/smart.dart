import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class Smart {
  final int? idSmart;
  final String? codeRFID;
  final int? available;
  final int? status;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final String? assingment;
  final int? idUser;

  Smart({
    this.idSmart,
    this.codeRFID,
    this.available,
    this.status,
    this.registerDate,
    this.lastUpdate,
    this.assingment,
    this.idUser
  });

  factory Smart.fromJson(Map<String, dynamic> json){
    DateFormat dateFormatWithGMT = DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'");
    DateFormat dateFormatWithoutGMT = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime? parseDate(String? dateString){
      if(dateString == null) return null;

      try{
        return dateFormatWithGMT.parse(dateString);
      } catch (e){
        try{
          return dateFormatWithoutGMT.parse(dateString);
        } catch (e){
          if (kDebugMode){
            print("Error al parsear la fecha: $dateString");
          }
          return null;
        }
      }
    }

    return Smart(
      idSmart: json['idSmart'],
      codeRFID: json['codeRFID'],
      registerDate: parseDate(json['registerDate']),
      lastUpdate: json['lastUpdate'] != null && json['lastUpdate'] != "Sin Cambios"
                  ? parseDate(json['lastUpdate'])
                  : null,
      available: json['available'],
      assingment: json['assignment'],
      idUser: json['idUser']
    );
  }

  Map<String, dynamic> toJsonInsert() {
    return {
      'code_rfid': codeRFID,
    };
  }

  Map<String, dynamic> toJsonUpdate() {
    return {
      'smart_id': idSmart,
      'code_rfid': codeRFID,
      'available': available,
      'user_id': idUser
    };
  }

  Map<String, dynamic> toJsonAssignment() {
    return {
      'smart_id': idSmart,
      'user_id': idUser
    };
  }

  Map<String, dynamic> toJsonDelete() {
    return {
      'smart_id': idSmart,
    };
  }
}