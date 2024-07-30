import 'package:hive/hive.dart';

class StaffGroupCrudOperations {
  final _staffDataBox = Hive.box('staffGroupDataBox');

  // CRUD Timestamp
  void writeTimestamp(int timestamp) {
    _staffDataBox.put('timestamp', timestamp);
  }

  int readTimestamp() {
    return _staffDataBox.get('timestamp', defaultValue: 0) as int;
  }

  // Write or Update Multiple Staff Groups
  void writeStaffGroups(List<Map<String, dynamic>> staffGroups) {
    final existingStaffGroups = readStaffGroups();

    for (var staffGroup in staffGroups) {
      existingStaffGroups[staffGroup['group_name']] = staffGroup;
    }

    _staffDataBox.put('staffGroups', existingStaffGroups);
  }

  // Read All Staff Groups
  Map<String, Map<String, dynamic>> readStaffGroups() {
    final rawData = _staffDataBox.get('staffGroups', defaultValue: {});
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

  // Delete Staff Groups
  void deleteStaffGroups(List<String> groupNames) {
    final staffGroups = readStaffGroups();
    for (var groupName in groupNames) {
      staffGroups.remove(groupName);
    }
    _staffDataBox.put('staffGroups', staffGroups);
  }
}
