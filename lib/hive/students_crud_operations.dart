import 'package:hive/hive.dart';

class StudentCrudOperations {
  final _studentDataBox = Hive.box('studentsDataBox');

  // CRUD Timestamp
  void writeTimestamp(int timestamp) {
    _studentDataBox.put('timestamp', timestamp);
  }

  int readTimestamp() {
    return _studentDataBox.get('timestamp', defaultValue: 0) as int;
  }

  // Write or Update Multiple Students
  void writeStudents(List<Map<String, dynamic>> students, String arrayName) {
    final existingStudents = readStudents(arrayName);

    for (var student in students) {
      existingStudents[student['student_admno']] = student;
    }

    _studentDataBox.put('${arrayName}Students', existingStudents);
  }

  // Read All Students
  Map<String, Map<String, dynamic>> readStudents(String arrayName) {
    final rawData =
        _studentDataBox.get('${arrayName}Students', defaultValue: {});
    if (rawData is Map) {
      return Map<String, Map<String, dynamic>>.from(
        rawData.map(
          (key, value) => MapEntry(
            key as String,
            Map<String, dynamic>.from(value as Map),
          ),
        ),
      );
    } else {
      return {};
    }
  }

  // Read Specific Student by student_id
  Map<String, dynamic>? readSpecificStudentById(String studentId) {
    final allStudents = readStudents("live")..addAll(readStudents("alumni"));

    for (var entry in allStudents.entries) {
      if (entry.value['student_admno'] != null &&
          entry.value['student_admno'].toString() == studentId) {
        return entry.value;
      }
    }

    return null; // Return null if the student_id is not found
  }

  // Delete Students
  void deleteStudents(List<String> admNos, String arrayName) {
    final students = readStudents(arrayName);
    for (var admNo in admNos) {
      students.remove(admNo);
    }
    _studentDataBox.put('${arrayName}Students', students);
  }
}
