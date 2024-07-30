import 'package:ajce_staff_contacts/apiData/get_dept.dart';
import 'package:ajce_staff_contacts/apiData/get_staff.dart';
import 'package:ajce_staff_contacts/apiData/get_staff_groups.dart';
import 'package:ajce_staff_contacts/authentication/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    await Future.wait([
      GetDept().getDepartmentsAPI(),
      GetStaff().getStaffContactsAPI(),
      GetStaffGroups().getStaffGroupsAPI(),
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
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
                          "Fetching...",
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
                        ),
                        child: Row(
                          children: [
                            const Spacer(),
                            Image.asset("assets/img/google.png"),
                            const Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
