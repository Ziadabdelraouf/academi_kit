class Class {
  String code;
  String name;
  int credits;
  int assignmentsCount;
  int examsCount;

  Class({
    required this.code,
    required this.name,
    required this.credits,
    this.assignmentsCount = 0,
    this.examsCount = 0,
  });

  factory Class.fromMap(Map<String, dynamic> map) {
    return Class(
      code: map['code'],
      name: map['name'],
      credits: map['credits'],
      assignmentsCount: map['assignmentsCount'],
      examsCount: map['examsCount'],
    );
  }
  void edit(String attribute, String value) {
    switch (attribute) {
      case 'name':
        name = value;
        break;
      case 'credits':
        credits = int.tryParse(value) ?? credits;
        break;
      case 'code':
        code = value;
        break;
      case 'assignmentsCount':
        assignmentsCount = int.tryParse(value) ?? assignmentsCount;
        break;
      case 'examsCount':
        examsCount = int.tryParse(value) ?? examsCount;
        break;
      default:
        throw Exception('Invalid attribute');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'credits': credits,
      'assignmentsCount': assignmentsCount,
      'examsCount': examsCount,
    };
  }
}
