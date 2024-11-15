import 'package:ps3_drops_v1/models/patient.dart' as PatientModel;
import 'package:ps3_drops_v1/models/nurse.dart' as NurseModel;
import 'package:ps3_drops_v1/models/balance.dart' as BalanceModel;
import 'package:ps3_drops_v1/models/therapy.dart' as TherapyModel;

class Therapy {
  final int? idSmart;
  final String? codeRFID;
  final DateTime? registerDate;
  final DateTime? lastUpdate;
  final int? status;

  Therapy(
      {this.idSmart,
      this.codeRFID,
      this.registerDate,
      this.lastUpdate,
      this.status});

  factory Therapy.fromJson(Map<String, dynamic> json) {
    return Therapy(
        idSmart: json['idSmart'],
        codeRFID: json['codeRFID'],
        registerDate: json['registerDate'] != null
            ? DateTime.parse(json['registerDate'])
            : null,
        lastUpdate: json['lastUpdate'] != null
            ? DateTime.parse(json['registerDate'])
            : null,
        status: json['status']);
  }
}
