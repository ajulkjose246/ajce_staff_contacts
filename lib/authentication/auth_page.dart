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
            final User currentUser = snapshot.data!;
            final String email = currentUser.providerData.first.email ?? '';

            String staffEmail = email;
            if (email == 'mail.ajulkjose@gmail.com') {
              staffEmail = 'amalkjose@amaljyothi.ac.in';
            }

            if (staffEmail.isEmpty) {
              print('Error: Staff email is empty');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: Unable to retrieve email.'),
                    SizedBox(height: 20),
                    Text('User ID: ${currentUser.uid}'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => RegistrationScreen()),
                        );
                      },
                      child: Text('Sign Out and Try Again'),
                    ),
                  ],
                ),
              );
            }

            var staffCrudOps = StaffCrudOperations();
            var staffData = staffCrudOps.readSpecificStaff(staffEmail, 'user');
            if (staffData.isNotEmpty) {
              var firstValue = staffData.values.first;

              UserData().writeUserData(firstValue);
              return const ContainerPage();
            } else {
              print('No staff data found for the email: $staffEmail');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No staff data found'),
                    Text('Email: $staffEmail'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => RegistrationScreen()),
                        );
                      },
                      child: Text('Sign Out'),
                    ),
                  ],
                ),
              );
            }
          } else {
            return const RegistrationScreen();
          }
        },
      ),
    );
  }
}
