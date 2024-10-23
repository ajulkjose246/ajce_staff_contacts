// ignore_for_file: avoid_print
import 'package:easy_url_launcher/easy_url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

class UrlLauncher {
  Future<void> whatsappUrl(String number, BuildContext context) async {
    try {
      // Check if the number starts with the Indian country code
      String formattedNumber = number.startsWith('91') ? number : '+91$number';

      // Remove any spaces or hyphens from the number
      formattedNumber = formattedNumber.replaceAll(RegExp(r'[\s-]'), '');

      await EasyLauncher.sendToWhatsApp(
          phone: formattedNumber, message: "Hello");
    } catch (e) {
      print('Error launching WhatsApp: $e');
      _showErrorDialog(context,
          'Unable to open WhatsApp. Please make sure it\'s installed or try again later.');
    }
  }

  Future<void> phoneUrl(String number) async {
    await EasyLauncher.call(number: number);
  }

  Future<void> mailUrl(String emailId) async {
    await EasyLauncher.email(email: emailId);
  }

  Future<void> shareContent(
      String name, String phone, String email, String imageUrl) async {
    try {
      // final tempDir = await getTemporaryDirectory();
      // final file = File('${tempDir.path}/photo.jpg');
      // final response = await http.get(Uri.parse(imageUrl));
      // await file.writeAsBytes(response.bodyBytes);
      final content = 'Name: $name\n'
          'Phone: +$phone\n'
          'Email: $email\n';
      Share.share(content);
    } catch (e) {
      print("Failed to share content: $e");
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
