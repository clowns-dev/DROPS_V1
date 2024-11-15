class Nurse {
  final int? idNurse;
  final String? fullName;
  final String? role;

  Nurse({
    this.idNurse,
    this.fullName,
    this.role,
  });

  factory Nurse.fromJson(Map<String, dynamic> json) {
    return Nurse(
      idNurse: json['idNurse'],
      fullName: json['fullName'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNurse': idNurse,
      'fullName': fullName,
      'role': role,
    };
  }
}
