import 'package:ajce_staff_contacts/apiData/get_dept.dart';
import 'package:ajce_staff_contacts/apiData/get_staff.dart';
import 'package:ajce_staff_contacts/apiData/get_staff_groups.dart';
import 'package:ajce_staff_contacts/authentication/auth_services.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        color: const Color.fromRGBO(236, 241, 244, 1),
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              width: 200,
              height: 200,
              child: Image.asset("assets/img/logo.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            _isLoading
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      Text(
                        "Getting ready, please wait...",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w900),
                      )
                    ],
                  )
                : GestureDetector(
                    onTap: () => AuthService().signInWithGoogle(),
                    child: Container(
                      height: 50,
                      width: 230,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/img/google.png",
                            height: 40,
                            width: 40,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Sign in with Google",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
