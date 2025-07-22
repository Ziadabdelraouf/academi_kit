// assignment.dart
class Assignment {
  final int? id;
  final String classCode;
  final String title;
  final String description;
  final DateTime dueDate;
  final int status; // 0 = pending, 1 = complete

  Assignment({
    this.id,
    required this.classCode,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'classCode': classCode,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'status': status,
    };
  }

  factory Assignment.fromMap(Map<String, dynamic> map) {
    return Assignment(
      id: map['id'],
      classCode: map['classCode'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['dueDate']),
      status: map['status'],
    );
  }
}
