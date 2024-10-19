import 'package:hive/hive.dart';

class UserData {
  final _userDataBox = Hive.box('userDataBox');

  // CRUD Timestamp
  void writeUserData(Map<String, dynamic> data) {
    _userDataBox.put('data', data);
  }

  Map<String, dynamic> readUserData() {
    final data = _userDataBox.get('data');
    if (data != null && data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return {"deptCode": 25};
  }
}
