// ignore_for_file: avoid_print

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  whatsappUrl(var number) async {
    final Uri url = Uri.parse("whatsapp://send?phone=$number");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print('Cannot launch URL');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  phoneUrl(var number) async {
    final Uri url = Uri(scheme: 'tel', path: "+$number");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print('Cannot launch URL');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  mailUrl(var emailid) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: emailid,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
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
}
