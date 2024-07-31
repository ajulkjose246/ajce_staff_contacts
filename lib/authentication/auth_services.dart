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
        Fluttertoast.showToast(msg: "Google sign-in canceled.");
        return null;
      }

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

      // Check if the email contains "@amaljyothi.ac.in"
      // if (userCredential.user?.providerData[0].email
      //         ?.contains('@mca.ajce.in') ??
      //     false) {
      Fluttertoast.showToast(msg: "Sign-in successful.");

      return userCredential;
      // } else {
      //   FirebaseAuth.instance.signOut();
      //   GoogleSignIn().signOut();
      //   Fluttertoast.showToast(
      //       msg: "Sign-in failed. Use your '@mca.ajce.in' email.");
      //   return null;
      // }
    } catch (e) {
      Fluttertoast.showToast(msg: "An error occurred: ${e.toString()}");
      return null;
    }
  }
}
