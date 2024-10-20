import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Initiate the sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn(scopes: [
        'email',
      ]).signIn();
      if (gUser == null) {
        print("Google sign-in canceled by user");
        Fluttertoast.showToast(msg: "Google sign-in canceled.");
        return null;
      }

      print("Google Sign-In account: ${gUser.email}");

      // Authenticate the user
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Sign in to Firebase with the Google user's credential
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Check if the email is available from the user object or provider data
      String? userEmail = userCredential.user?.email;
      if (userEmail == null &&
          userCredential.user?.providerData.isNotEmpty == true) {
        userEmail = userCredential.user?.providerData.first.email;
      }

      if (userEmail == null) {
        print("Error: Unable to retrieve user email");
        Fluttertoast.showToast(
          msg: "Error: Unable to retrieve user email",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
        );
        return null;
      }

      // Check if the email is allowed
      if (userEmail.endsWith('@amaljyothi.ac.in') ||
          userEmail == 'mail.ajulkjose@gmail.com') {
        Fluttertoast.showToast(
          msg: "Sign-in successful.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
        );
        return userCredential;
      } else {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        Fluttertoast.showToast(
          msg:
              "Sign-in failed. Use your '@amaljyothi.ac.in' email or the authorized Gmail account.",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 2,
        );
        return null;
      }
    } catch (e) {
      print("Error during sign-in: ${e.toString()}");
      Fluttertoast.showToast(
        msg: "An error occurred: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2,
      );
      return null;
    }
  }
}
