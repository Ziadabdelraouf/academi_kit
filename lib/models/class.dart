class Class {
  final String code;
  final String name;
  final int credits;
  final int assignmentsCount;
  final int examsCount;

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
