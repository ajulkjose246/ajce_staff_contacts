// ignore_for_file: avoid_print, prefer_const_constructors

import 'package:ajce_staff_contacts/authentication/registration_screen.dart';
import 'package:ajce_staff_contacts/hive/staff_crud_operations.dart';
import 'package:ajce_staff_contacts/hive/user_data.dart';
import 'package:ajce_staff_contacts/screens/container_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var staffData = StaffCrudOperations()
                .readSpecificStaff('binumonjosephk@amaljyothi.ac.in', 'user');
            if (staffData.isNotEmpty) {
              var firstValue = staffData.values.first;
              print(firstValue);
              UserData().writeUserData(firstValue);
            } else {
              print('No staff data found for the specified email.');
            }

            // UserData().writeUserData(StaffCrudOperations()
            //     .readSpecificStaff('binumonjosephk@amaljyothi.ac.in', 'user')
            //     .values
            //     .first);

            return const ContainerPage();
          } else {
            return const RegistrationScreen();
          }
        },
      ),
    );
  }
}
