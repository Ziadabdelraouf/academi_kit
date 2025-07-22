class Exam {
  final int? id;
  final String classCode;
  final String title;
  final String description;
  final DateTime examDate;
  final int status; // 0 = upcoming, 1 = completed

  Exam({
    this.id,
    required this.classCode,
    required this.title,
    required this.description,
    required this.examDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classCode': classCode,
      'title': title,
      'description': description,
      'examDate': examDate.toIso8601String(),
      'status': status,
    };
  }

  factory Exam.fromMap(Map<String, dynamic> map) {
    return Exam(
      id: map['id'],
      classCode: map['classCode'],
      title: map['title'],
      description: map['description'],
      examDate: DateTime.parse(map['examDate']),
      status: map['status'],
    );
  }
}
