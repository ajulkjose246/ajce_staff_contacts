import 'dart:isolate';
import 'package:ajce_staff_contacts/screens/event_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:ajce_staff_contacts/apiData/get_dept.dart';
import 'package:ajce_staff_contacts/apiData/get_staff.dart';
import 'package:ajce_staff_contacts/apiData/get_staff_groups.dart';
import 'package:ajce_staff_contacts/components/staff_listview.dart';
import 'package:ajce_staff_contacts/hive/dept_crud_operations.dart';
import 'package:ajce_staff_contacts/hive/staff_group_crud_operations.dart';
import 'package:ajce_staff_contacts/hive/students_crud_operations.dart';
import 'package:ajce_staff_contacts/hive/user_data.dart';
import 'package:ajce_staff_contacts/screens/department_page.dart';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:ajce_staff_contacts/screens/home_page.dart';
import 'package:ajce_staff_contacts/screens/settings_page.dart';
import 'package:ajce_staff_contacts/screens/students.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ContainerPage extends StatefulWidget {
  const ContainerPage({super.key});

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    DepartmentPage(),
    EventPage(),
    UtilityPage(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _textEditingController.dispose();
    _focusNode.dispose();
    _con.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  late AnimationController _con;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  int toggle = 0;
  String typedText = '';
  bool _isLoading = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isConnecting = false;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _con = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
    );
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  void _toggleSearch() {
    setState(() {
      if (toggle == 0) {
        toggle = 1;
        _con.forward();
        _focusNode.requestFocus();
      } else {
        toggle = 0;
        _textEditingController.clear();
        typedText = '';
        _con.reverse();
        _focusNode.unfocus();
      }
    });
  }

  void _toggleAudio() async {
    final String audioUrl = 'https://icecast.octosignals.com/radio90_final';

    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      setState(() {
        _isConnecting = true;
      });
      try {
        await _audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          _isPlaying = true;
          _isConnecting = false;
        });
      } catch (e) {
        setState(() {
          _isConnecting = false;
        });
        print('Error playing audio: $e');
      }
    }
  }

  SendPort? homePort;
  String? latestMessageFromOverlay;

  Future<void> _loadData(int deptCode) async {
    bool staffTimestampSet = StaffCrudOperations().writeTimestamp(0);
    bool staffGroupTimestampSet = StaffGroupCrudOperations().writeTimestamp(0);
    bool deptTimestampSet = DeptCrudOperations().writeTimestamp(0);

    if (staffTimestampSet && staffGroupTimestampSet && deptTimestampSet) {
      try {
        await Future.wait([
          GetDept().getDepartmentsAPI(),
          GetStaff().getStaffContactsAPI(),
          GetStaffGroups().getStaffGroupsAPI(),
        ]);
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData = UserData().readUserData();

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(137, 14, 79, 1),
        elevation: 20,
        title: const Text(
          'AJCE Companion',
          style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
        ),
        actions: [
          Stack(
            children: [
              PopupMenuButton<int>(
                onSelected: (value) async {
                  if (value == 0) {
                    _loadData(userData['deptCode']);
                  } else if (value == 1) {
                    try {
                      bool staffTimestampSet =
                          StaffCrudOperations().writeTimestamp(0);
                      bool staffGroupTimestampSet =
                          StaffGroupCrudOperations().writeTimestamp(0);
                      bool deptTimestampSet =
                          DeptCrudOperations().writeTimestamp(0);
                      bool studentTimestampSet =
                          StudentCrudOperations().writeTimestamp(0);

                      if (staffTimestampSet &&
                          staffGroupTimestampSet &&
                          deptTimestampSet &&
                          studentTimestampSet) {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
                      }
                    } catch (e) {
                      print('Sign out error: $e');
                    }
                  } else if (value == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage()));
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.sync,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Resync'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Log Out'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          Icons.settings,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Settings'),
                      ],
                    ),
                  ),
                ],
                offset: Offset(0, 40),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: userData['photo'] ?? "",
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ), // Adjust this offset as needed
              ),
            ],
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: !_isLoading
          ? Stack(
              children: [
                PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: _widgetOptions,
                ),
                if (_focusNode.hasFocus)
                  typedText.isEmpty
                      ? Container()
                      : Positioned(
                          right: 70.0,
                          bottom: 70.0,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 80,
                            height: StaffCrudOperations()
                                        .readSpecificStaff(typedText, "name")
                                        .length >
                                    4
                                ? 260
                                : (StaffCrudOperations()
                                        .readSpecificStaff(typedText, "name")
                                        .length *
                                    65),
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
                              itemCount: StaffCrudOperations()
                                  .readSpecificStaff(typedText, "name")
                                  .length,
                              itemBuilder: (context, index) {
                                var staffData = StaffCrudOperations()
                                    .readSpecificStaff(typedText, "name")
                                    .values
                                    .toList()[index];
                                return StaffListview(
                                  staffCode: staffData['staffCode'],
                                );
                              },
                            ),
                          ),
                        ),
                // Search bar
                toggle == 1
                    ? AnimatedPositioned(
                        duration: const Duration(milliseconds: 375),
                        right: (toggle == 0)
                            ? 10.0
                            : 70.0, // Adjust the right position
                        bottom: 10.0,
                        curve: Curves.easeOut,
                        child: AnimatedOpacity(
                          opacity: (toggle == 0) ? 0.0 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            height:
                                50.0, // Adjusted height for better usability
                            width: size.width -
                                80, // Adjusted width for better usability
                            padding: const EdgeInsets.symmetric(
                                horizontal:
                                    16.0), // Padding inside the search bar
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(137, 14, 79,
                                  1), // Background color for the search bar
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
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
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
                      )
                    : Container(),
                // Search/Close icon button
                _selectedIndex != 3
                    ? Positioned(
                        bottom: 10.0,
                        right: 10.0,
                        child: Material(
                          color: const Color.fromRGBO(137, 14, 79, 1),
                          borderRadius: BorderRadius.circular(30.0),
                          child: IconButton(
                            splashRadius: 19.0,
                            icon: Icon(
                              toggle == 0 ? Icons.search : Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: _toggleSearch,
                          ),
                        ),
                      )
                    : Container(),

                // Modified Floating Action Button
                _selectedIndex != 3
                    ? Positioned(
                        bottom: 70.0,
                        right: 10.0,
                        child: Material(
                          color: const Color.fromRGBO(137, 14, 79, 1),
                          borderRadius: BorderRadius.circular(30.0),
                          child: IconButton(
                            splashRadius: 19.0,
                            icon: _isConnecting
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : _isPlaying
                                    ? Icon(
                                        Icons.stop,
                                        color: Colors.white,
                                      )
                                    : Image.asset(
                                        'assets/img/radio.png',
                                        width: 30,
                                        height: 30,
                                        color: Colors.white,
                                      ),
                            onPressed: _isConnecting ? null : _toggleAudio,
                          ),
                        ),
                      )
                    : Container(),
              ],
            )
          : CircularProgressIndicator(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color.fromRGBO(137, 14, 79, 1),
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.apartment,
                  text: 'Departments',
                ),
                GButton(
                  icon: Icons.event_note_outlined,
                  text: 'Events',
                ),
                GButton(
                  icon: Icons.groups,
                  text: 'Students',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}
