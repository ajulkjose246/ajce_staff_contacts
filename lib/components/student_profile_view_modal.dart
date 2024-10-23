// ignore_for_file: non_constant_identifier_names

import 'package:ajce_staff_contacts/components/error_image.dart';
import 'package:ajce_staff_contacts/components/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<dynamic> StudentProfileView(
    BuildContext context, Map<String, dynamic> studentData) {
  print(studentData);
  Size size = MediaQuery.of(context).size;
  return showModalBottomSheet(
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(22),
        topRight: Radius.circular(22),
      ),
    ),
    builder: (BuildContext context) {
      bool showMoreDetails = false;

      // Helper function to copy text and show toast
      void copyToClipboard(String text) {
        Clipboard.setData(ClipboardData(text: text));
        Fluttertoast.showToast(
          msg: "Copied to clipboard",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      // Helper function to combine and split contact information
      List<String> combineAndSplit(dynamic value1, dynamic value2) {
        String combined = '';
        if (value1 != null && value1.toString().isNotEmpty) {
          combined += value1.toString();
        }
        if (value2 != null && value2.toString().isNotEmpty) {
          if (combined.isNotEmpty) combined += ',';
          combined += value2.toString();
        }
        return combined.isEmpty
            ? []
            : combined.split(',').map((e) => e.trim()).toList();
      }

      // Combine mobile numbers and emails
      final List<String> phoneNumbers = combineAndSplit(
          studentData['student_mobile'], studentData['student_mobiles']);
      final List<String> emails = combineAndSplit(
          studentData['student_email'], studentData['student_emails']);

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return GestureDetector(
            onTap: () {}, // This prevents taps from dismissing the modal
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Custom drag handle
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: studentData['student_photo'] ?? "",
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  placeholder: (context, url) {
                                    final studentName =
                                        studentData['student_name'] ??
                                            'Unknown';
                                    final firstLetter = studentName.isNotEmpty
                                        ? studentName[0].toUpperCase()
                                        : '?';
                                    return ErrorImage(
                                      firstLetter: firstLetter,
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    final studentName =
                                        studentData['student_name'] ??
                                            'Unknown';
                                    final firstLetter = studentName.isNotEmpty
                                        ? studentName[0].toUpperCase()
                                        : '?';
                                    return ErrorImage(
                                      firstLetter: firstLetter,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${studentData['student_name']} ( ${studentData['student_admno']} ) ",
                            style: TextStyle(
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w900),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${studentData['student_type']} / ${studentData['student_batch']}",
                            style: TextStyle(
                                fontSize: size.width * 0.04,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),

                          // New position for expand/collapse button
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  showMoreDetails = !showMoreDetails;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      showMoreDetails
                                          ? "Less Details"
                                          : "More Details",
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      showMoreDetails
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: size.width * 0.05,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (phoneNumbers.isNotEmpty) ...[
                                GestureDetector(
                                  onTap: () async {
                                    final List<String> phoneNumbers =
                                        studentData['student_mobile']
                                            .split(',');
                                    phoneNumbers.length != 1
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Select a Number to Call',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: phoneNumbers
                                                        .map((phone) {
                                                      return GestureDetector(
                                                        onTap: () =>
                                                            UrlLauncher()
                                                                .phoneUrl(
                                                                    phone),
                                                        child: GestureDetector(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "+$phone",
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                              const Icon(Icons
                                                                  .phone_outlined)
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : await FlutterPhoneDirectCaller
                                            .callNumber(
                                                studentData['student_mobile']);

                                    // : UrlLauncher().phoneUrl(
                                    //     studentData['contact_mobiles']);
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(229, 230, 255, 1),
                                      ),
                                      child: const Icon(LineIcons.phone),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () => UrlLauncher()
                                      .whatsappUrl(phoneNumbers.first, context),
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(229, 230, 255, 1),
                                      ),
                                      child: const Icon(LineIcons.whatSApp),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                              if (emails.isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    final List<String> mailId =
                                        studentData['student_emails']
                                            .split(',');
                                    mailId.length != 1
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Select a Mail Id',
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children:
                                                        mailId.map((mail) {
                                                      return GestureDetector(
                                                          onTap: () =>
                                                              UrlLauncher()
                                                                  .mailUrl(
                                                                      mail),
                                                          child:
                                                              GestureDetector(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 200,
                                                                    child: Text(
                                                                      mail,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      softWrap:
                                                                          false,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const Icon(Icons
                                                                      .mail_outline)
                                                                ],
                                                              ),
                                                            ),
                                                          ));
                                                    }).toList(),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : UrlLauncher().mailUrl(
                                            studentData['student_emails']);
                                  },
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color.fromRGBO(229, 230, 255, 1),
                                      ),
                                      child: const Icon(Icons.mail_outline),
                                    ),
                                  ),
                                ),
                              if (emails.isNotEmpty || phoneNumbers.isNotEmpty)
                                const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  UrlLauncher().shareContent(
                                    studentData['student_name'],
                                    phoneNumbers.isNotEmpty
                                        ? phoneNumbers.first
                                        : "",
                                    emails.isNotEmpty ? emails.first : "",
                                    studentData['student_photo'],
                                  );
                                },
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(229, 230, 255, 1),
                                    ),
                                    child: const Icon(LineIcons.share),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  // TODO: Implement info action
                                },
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(229, 230, 255, 1),
                                    ),
                                    child: const Icon(LineIcons.infoCircle),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AnimatedCrossFade(
                            firstChild: const SizedBox(),
                            secondChild: Column(
                              children: [
                                const SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      "Contact Details:",
                                      style: TextStyle(
                                          fontSize: size.width * 0.035,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(
                                          229, 230, 255, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Phone:",
                                            style: TextStyle(
                                              fontSize: size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          if (phoneNumbers.isNotEmpty)
                                            ...phoneNumbers.map((number) =>
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.phone_outlined,
                                                          size: size.width *
                                                              0.04),
                                                      const SizedBox(width: 5),
                                                      Expanded(
                                                        child: Text(
                                                          number,
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.035,
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.copy,
                                                            size: size.width *
                                                                0.04),
                                                        onPressed: () =>
                                                            copyToClipboard(
                                                                number),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          else
                                            Text(
                                              'No contact mobiles available',
                                              style: TextStyle(
                                                fontSize: size.width * 0.035,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                          const SizedBox(height: 10),
                                          Text(
                                            "E-Mail:",
                                            style: TextStyle(
                                              fontSize: size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          if (emails.isNotEmpty)
                                            ...emails.map((email) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 5),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.mail_outline,
                                                          size: size.width *
                                                              0.04),
                                                      const SizedBox(width: 5),
                                                      Expanded(
                                                        child: Text(
                                                          email,
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.035,
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        icon: Icon(Icons.copy,
                                                            size: size.width *
                                                                0.04),
                                                        onPressed: () =>
                                                            copyToClipboard(
                                                                email),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          else
                                            Text(
                                              'No contact emails available',
                                              style: TextStyle(
                                                fontSize: size.width * 0.035,
                                                color: Colors.grey[700],
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                            crossFadeState: showMoreDetails
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            duration: const Duration(milliseconds: 300),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
