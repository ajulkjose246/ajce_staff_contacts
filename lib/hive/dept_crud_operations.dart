import 'package:hive/hive.dart';

class DeptCrudOperations {
  final _staffDataBox = Hive.box('deptDataBox');

  // CRUD Timestamp
  void writeTimestamp(int timestamp) {
    _staffDataBox.put('timestamp', timestamp);
  }

  int readTimestamp() {
    return _staffDataBox.get('timestamp', defaultValue: 0);
  }

  // Write or Update Multiple Departments
  void writeDepartments(List<Map<String, dynamic>> departments) {
    // Retrieve existing departments, ensure type consistency
    final existingDepartments = readDepartments();

    // Create a map from the new departments list
    final newDepartments = {
      for (var dept in departments) (dept['deptCode'] as int): dept
    };

    // Merge new departments with existing ones
    existingDepartments.addAll(newDepartments);

    // Save the merged map back to Hive
    _staffDataBox.put('departments', existingDepartments);
  }

  // Read All Departments
  Map<int, Map<String, dynamic>> readDepartments() {
    final rawData = _staffDataBox.get('departments', defaultValue: {});
    if (rawData is Map) {
      return Map<int, Map<String, dynamic>>.from(rawData.map((key, value) =>
          MapEntry(key as int, Map<String, dynamic>.from(value as Map))));
    } else {
      return {};
    }
  }

  Map<String, dynamic>? getDepartmentByCode(int deptCode) {
    final departmentData = readDepartments();

    if (departmentData.containsKey(deptCode)) {
      return departmentData[deptCode];
    } else {
      return null;
    }
  }

  // Delete Departments
  void deleteDepartments(List<int> deptCodes) {
    final departments = readDepartments();
    for (var code in deptCodes) {
      departments.remove(code);
    }
    _staffDataBox.put('departments', departments);
  }
}
