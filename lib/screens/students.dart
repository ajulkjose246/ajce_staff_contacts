import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:ajce_staff_contacts/components/error_image.dart';
import 'package:ajce_staff_contacts/components/student_listview.dart';
import 'package:ajce_staff_contacts/hive/students_crud_operations.dart';
import 'package:ajce_staff_contacts/screens/student_list.dart';
import 'package:flutter/material.dart';
import 'package:ajce_staff_contacts/apiData/get_students.dart';
import 'package:ajce_staff_contacts/components/student_profile_view_modal.dart';

class UtilityPage extends StatefulWidget {
  const UtilityPage({Key? key}) : super(key: key);

  @override
  State<UtilityPage> createState() => _UtilityPageState();
}

class _UtilityPageState extends State<UtilityPage> {
  var filterValue = 1;
  String typedText = '';
  bool toggle = false;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> _handleScannedAdmissionNumber(String admissionNumber) async {
    // Convert the scanned string to an integer
    int? adminNo = int.tryParse(admissionNumber);
    if (adminNo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid admission number')),
      );
      return;
    }

    // Fetch student details
    final studentDetails = await GetStudents().getSpecificStudent(adminNo);
    if (studentDetails != null && studentDetails['stud'] != null) {
      final studData = studentDetails['stud'] as Map<String, dynamic>;

      // Convert the API response to match the expected format for StudentProfileView
      final formattedStudentData = {
        'student_name': studData['studentName'],
        'student_type': studData['accommodation'],
        'student_photo': studData['photo'],
        'student_mobile': studData['fatherno'],
        'student_mobiles': studData['fatherno'],
        'className': studData['className'],
        'deptShort': studData['deptShort'],
        'ctname': studData['ctname'],
        'ctcontact': studData['ctcontact'],
        'room_num': studData['room_num'],
      };

      // Show the StudentProfileView modal
      await StudentProfileView(context, formattedStudentData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student not found or data incomplete')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var studentsFilterList = [];
    var studentsList = filterValue == 1
        ? StudentCrudOperations().readStudents("live").values.toList()
        : StudentCrudOperations().readStudents("alumni").values.toList();

    var studentBatchSet = studentsList
        .map((student) => student['student_batch'])
        .toSet()
        .toList();

    // Filter the students list based on the search query
    if (typedText.isNotEmpty) {
      studentsFilterList = studentsList
          .where((student) => student['student_name']
              .toLowerCase()
              .contains(typedText.toLowerCase()))
          .toList();
    }

    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(236, 241, 244, 1),
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFilterButton(1, "Live Students", size),
                      const SizedBox(width: 10),
                      _buildFilterButton(3, "Alumni Students", size),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: studentBatchSet.length,
                    itemBuilder: (context, index) {
                      final batchName = studentBatchSet[index] ?? 'Unknown';
                      final firstLetter = batchName.isNotEmpty
                          ? batchName[0].toUpperCase()
                          : '?';
                      return GestureDetector(
                        onTap: () {
                          var filteredAdmnoList = studentsList
                              .where((student) {
                                return student['student_batch'] ==
                                    studentBatchSet[index];
                              })
                              .map((student) => student['student_admno'])
                              .toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentList(
                                batchName: studentBatchSet[index],
                                studentsList: filteredAdmnoList,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 5, right: 10, left: 10),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: ErrorImage(
                                          firstLetter: firstLetter,
                                        )),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${studentBatchSet[index]}",
                                        style: TextStyle(
                                            fontSize: size.width * 0.04,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                const Icon(Icons.keyboard_arrow_right),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            if (_focusNode.hasFocus && typedText.isNotEmpty)
              Positioned(
                right: 70.0,
                bottom: 70.0,
                child: Container(
                  width: MediaQuery.of(context).size.width - 80,
                  height: studentsFilterList.length > 4
                      ? 260
                      : studentsFilterList.length * 65,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: studentsFilterList.length,
                    itemBuilder: (context, index) {
                      return StudentListview(
                          studentCode: studentsFilterList[index]
                              ['student_admno']);
                    },
                  ),
                ),
              ),
            if (toggle)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 375),
                right: 70.0,
                bottom: 10.0,
                curve: Curves.easeOut,
                child: AnimatedOpacity(
                  opacity: toggle ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    height: 50.0,
                    width: MediaQuery.of(context).size.width - 80,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(137, 14, 79, 1),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _textEditingController,
                      focusNode: _focusNode,
                      cursorRadius: const Radius.circular(10.0),
                      cursorWidth: 2.0,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        setState(() {
                          typedText = value;
                        });
                      },
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: 'Search...',
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 70.0,
              right: 10.0,
              child: Material(
                color: const Color.fromRGBO(137, 14, 79, 1),
                borderRadius: BorderRadius.circular(30.0),
                child: IconButton(
                  splashRadius: 19.0,
                  icon: const Icon(Icons.qr_code_scanner_outlined,
                      color: Colors.white),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AiBarcodeScanner(
                          onDispose: () {
                            // This is called when the barcode scanner is disposed.
                            debugPrint("Barcode scanner disposed!");
                          },
                          hideGalleryButton:
                              false, // Show or hide the gallery button
                          controller: MobileScannerController(
                            detectionSpeed: DetectionSpeed
                                .noDuplicates, // Adjust detection speed
                          ),
                          onDetect: (BarcodeCapture capture) {
                            final String? scannedValue =
                                capture.barcodes.first.rawValue;
                            debugPrint("Barcode scanned: $scannedValue");

                            if (scannedValue != null) {
                              _handleScannedAdmissionNumber(scannedValue);
                            }
                          },
                          validator: (value) {
                            if (value.barcodes.isEmpty) {
                              return false;
                            }
                            // Validate that the scanned value is a number
                            final scannedValue = value.barcodes.first.rawValue;
                            return scannedValue != null &&
                                int.tryParse(scannedValue) != null;
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Material(
                color: const Color.fromRGBO(137, 14, 79, 1),
                borderRadius: BorderRadius.circular(30.0),
                child: IconButton(
                  splashRadius: 19.0,
                  icon: Icon(toggle ? Icons.close : Icons.search,
                      color: Colors.white),
                  onPressed: _toggleSearch,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(int value, String label, Size size) {
    // Calculate responsive width and height
    double buttonWidth = size.width * 0.27;
    double buttonHeight = 35;

    return GestureDetector(
      onTap: () {
        setState(() {
          filterValue = value;
        });
      },
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        decoration: BoxDecoration(
          color: filterValue == value
              ? const Color.fromRGBO(137, 14, 79, 1)
              : Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: filterValue == value ? Colors.white : Colors.black,
              fontSize: size.width * 0.03, // Responsive font size
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSearch() {
    setState(() {
      toggle = !toggle;
      if (!toggle) {
        typedText = '';
        _textEditingController.clear();
        _focusNode.unfocus();
      }
    });
  }
}
