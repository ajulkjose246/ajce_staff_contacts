import 'package:hive/hive.dart';

class StaffCrudOperations {
  final _staffDataBox = Hive.box('staffDataBox');

  // CRUD Timestamp
  void writeTimestamp(int timestamp) {
    _staffDataBox.put('timestamp', timestamp);
  }

  int readTimestamp() {
    return _staffDataBox.get('timestamp') ?? 0;
  }

  // Write or Update Multiple Staff Members
  void writeStaff(List<Map<String, dynamic>> staffMembers) {
    // Retrieve existing staff members, ensure type consistency
    final existingStaff = readStaff();

    // Create a map from the new staff members list
    final newStaff = {
      for (var staff in staffMembers) (staff['staffCode'] as int): staff
    };

    // Merge new staff members with existing ones
    existingStaff.addAll(newStaff);

    // Save the merged map back to Hive
    _staffDataBox.put('staff', existingStaff);
  }

  // Read All Staff Members
  Map<int, Map<String, dynamic>> readStaff() {
    final rawData = _staffDataBox.get('staff', defaultValue: {});
    if (rawData is Map) {
      return Map<int, Map<String, dynamic>>.from(rawData.map((key, value) =>
          MapEntry(key as int, Map<String, dynamic>.from(value as Map))));
    } else {
      return {};
    }
  }

  Map<String, int> getStaffGenderCounts() {
    final rawData = _staffDataBox.get('staff', defaultValue: {});
    int maleCount = 0;
    int femaleCount = 0;

    for (var entry in rawData.values) {
      if (entry.containsKey('gender')) {
        final gender = entry['gender'].toString().toLowerCase();
        if (gender == 'male') {
          maleCount++;
        } else if (gender == 'female') {
          femaleCount++;
        }
      }
    }

    return {
      'totalMale': maleCount,
      'totalFemale': femaleCount,
    };
  }

  Map<String, int> getStaffGenderCountsByDepartment(int department) {
    final rawData = _staffDataBox.get('staff', defaultValue: {});

    int maleCount = 0;
    int femaleCount = 0;

    final filteredData = rawData.values.where((entry) =>
        entry.containsKey('deptCode') &&
        entry['deptCode'] == department); // Ensure exact match

    for (var entry in filteredData) {
      if (entry.containsKey('gender')) {
        final gender = entry['gender'].toString().toLowerCase();
        if (gender == 'male') {
          maleCount++;
        } else if (gender == 'female') {
          femaleCount++;
        }
      }
    }

    return {
      'departmentMale': maleCount,
      'departmentFemale': femaleCount,
    };
  }

  Map<int, Map<String, dynamic>> readSpecificStaff(var value, String type) {
    String q;
    if (type == 'dept') {
      q = 'deptCode';
    } else if (type == 'user') {
      q = 'contact_emails';
    } else if (type == 'name') {
      q = 'staffName';
    } else {
      q = 'staffCode';
    }

    final rawData = _staffDataBox.get('staff', defaultValue: {});
    if (rawData is Map) {
      final Map<int, Map<String, dynamic>> staffData =
          Map<int, Map<String, dynamic>>.from(rawData.map((key, value) =>
              MapEntry(key as int, Map<String, dynamic>.from(value as Map))));

      final filteredData = Map<int, Map<String, dynamic>>.fromEntries(
          staffData.entries.where((entry) {
        if (type == 'user') {
          return entry.value[q] != null &&
              entry.value[q].split(',').map((e) => e.trim()).contains(value);
        } else if (type == 'name') {
          return entry.value[q] != null &&
              entry.value[q]
                  .toString()
                  .toLowerCase()
                  .contains(value.toString().toLowerCase());
        } else {
          return entry.value[q] == value;
        }
      }));
      // Convert filtered data to a list and sort based on the designation
      final sortedList = filteredData.entries.toList()
        ..sort((a, b) {
          if (a.value['designation'] == 'HOD') {
            return -1;
          } else if (b.value['designation'] == 'HOD') {
            return 1;
          } else {
            return a.value['designation']
                .toString()
                .compareTo(b.value['designation'].toString());
          }
        });

      // Convert the sorted list back to a map
      final sortedData = Map<int, Map<String, dynamic>>.fromEntries(sortedList);
      return sortedData;
    } else {
      return {};
    }
  }

  // Delete Staff Members
  void deleteStaff(List<int> staffCodes) {
    final staff = readStaff();
    for (var code in staffCodes) {
      staff.remove(code);
    }
    _staffDataBox.put('staff', staff);
  }
}
