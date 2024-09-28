class Person {
  ///Propiedades
  final int? idPerson;
  final String name;
  final String lastName;
  final String secondLastName;
  final String birthDate;
  final String ci;
  final DateTime? lastUpdate;
  final int? userID;

  ///Constructor
  Person({
    this.idPerson,
    required this.name,
    required this.lastName,
    required this.secondLastName,
    required this.birthDate,
    required this.ci,
    this.lastUpdate,
    this.userID
  });
  
  ///Mapeo a Json
  factory Person.fromJson(Map<String, dynamic> json){
    return Person(
      idPerson: json['idPerson'],
      name: json['name'],
      lastName: json['lastName'],
      secondLastName: json['secondLastName'],
      birthDate: json['birthDate'],
      ci: json['ci'],
      userID: json['userID']
    );
  }
}