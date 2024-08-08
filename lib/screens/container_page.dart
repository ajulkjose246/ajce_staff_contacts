import 'dart:isolate';

import 'package:ajce_staff_contacts/components/user_listview.dart';
import 'package:ajce_staff_contacts/screens/department_page.dart';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:ajce_staff_contacts/screens/home_page.dart';
import 'package:ajce_staff_contacts/screens/staff_groups.dart';
import 'package:ajce_staff_contacts/screens/utility_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phone_state/phone_state.dart';
import 'package:system_alert_window/system_alert_window.dart';

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
    StaffGroups(),
    // UtilityPage(),
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
    SystemAlertWindow.removeOnClickListener();
    super.dispose();
  }

  late AnimationController _con;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  int toggle = 0;
  String typedText = '';

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
    _con = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 375),
    );
    _requestPermissions();
    _listenPhoneState();
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

  bool _isShowingWindow = false;
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
  SendPort? homePort;
  String? latestMessageFromOverlay;

  void _listenPhoneState() {
    PhoneState.stream.listen((event) {
      switch (event.status) {
        case PhoneStateStatus.CALL_INCOMING:
        case PhoneStateStatus.CALL_STARTED:
          _showOverlayWindow();
          print("container page");
          print(event.number);
          print("container page");
          break;
        case PhoneStateStatus.CALL_ENDED:
          _hideOverlayWindow();
          break;
        case PhoneStateStatus.NOTHING:
          break;
      }
    });
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  void _showOverlayWindow() async {
    if (!_isShowingWindow) {
      await SystemAlertWindow.sendMessageToOverlay('show system window');
      SystemAlertWindow.showSystemWindow(
          height: 200,
          width: MediaQuery.of(context).size.width.floor(),
          gravity: SystemWindowGravity.CENTER,
          prefMode: prefMode);
      setState(() {
        _isShowingWindow = true;
      });
    }
  }

  void _hideOverlayWindow() async {
    if (_isShowingWindow) {
      setState(() {
        _isShowingWindow = false;
      });
      await SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await GoogleSignIn().signOut();
              },
              icon: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(
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
                          return UserListview(
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
                  right:
                      (toggle == 0) ? 10.0 : 70.0, // Adjust the right position
                  bottom: 10.0,
                  curve: Curves.easeOut,
                  child: AnimatedOpacity(
                    opacity: (toggle == 0) ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      height: 50.0, // Adjusted height for better usability
                      width: size.width -
                          80, // Adjusted width for better usability
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0), // Padding inside the search bar
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
        ],
      ),
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
                  icon: Icons.group,
                  text: 'Teams',
                ),
                // GButton(
                //   icon: Icons.engineering,
                //   text: 'Utilities',
                // ),
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
