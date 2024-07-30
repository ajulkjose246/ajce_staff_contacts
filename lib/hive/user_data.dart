import 'package:hive/hive.dart';

class UserData {
  final _userDataBox = Hive.box('userDataBox');

  // CRUD Timestamp
  void writeUserData(Map<String, dynamic> data) {
    _userDataBox.put('data', data);
  }

  Map<String, dynamic> readUserData() {
    return _userDataBox.get('data') ?? {"deptCode": 25};
  }
}
