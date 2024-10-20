// ignore_for_file: non_constant_identifier_names

import 'package:ajce_staff_contacts/components/error_image.dart';
import 'package:ajce_staff_contacts/components/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

Future<dynamic> StudentProfileView(
    BuildContext context, Map<String, dynamic> studentData) {
  Size size = MediaQuery.of(context).size;
  return showModalBottomSheet(
    isDismissible: true,
    showDragHandle: true,
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

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: showMoreDetails ? 650 : 300,
            child: Center(
              child: ListView(
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
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) {
                              final studentName =
                                  studentData['student_name'] ?? 'Unknown';
                              final firstLetter = studentName.isNotEmpty
                                  ? studentName[0].toUpperCase()
                                  : '?';
                              return ErrorImage(
                                firstLetter: firstLetter,
                              );
                            }),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${studentData['student_name']} ( ${studentData['student_type']} ) ",
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
                    "${studentData['student_admno']}",
                    style: TextStyle(
                        fontSize: size.width * 0.04,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      studentData['student_mobile'] != null
                          ? GestureDetector(
                              onTap: () async {
                                final List<String> phoneNumbers =
                                    studentData['student_mobile'].split(',');
                                phoneNumbers.length != 1
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Select a Number to Call',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children:
                                                    phoneNumbers.map((phone) {
                                                  return GestureDetector(
                                                    onTap: () => UrlLauncher()
                                                        .phoneUrl(phone),
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
                                    : await FlutterPhoneDirectCaller.callNumber(
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
                            )
                          : Container(),
                      const SizedBox(
                        width: 20,
                      ),
                      studentData['student_mobile'] != null
                          ? GestureDetector(
                              onTap: () => UrlLauncher()
                                  .whatsappUrl(studentData['student_mobile']),
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
                            )
                          : Container(),
                      const SizedBox(
                        width: 20,
                      ),
                      studentData['student_emails'] != null
                          ? GestureDetector(
                              onTap: () async {
                                final List<String> mailId =
                                    studentData['student_emails'].split(',');
                                mailId.length != 1
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Select a Mail Id',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: mailId.map((mail) {
                                                  return GestureDetector(
                                                    onTap: () => UrlLauncher()
                                                        .mailUrl(mail),
                                                    child: GestureDetector(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5),
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
                                                                softWrap: false,
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                ),
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .mail_outline)
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : UrlLauncher()
                                        .mailUrl(studentData['student_emails']);
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
                            )
                          : Container(),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          UrlLauncher().shareContent(
                              studentData['student_name'],
                              studentData['student_mobile'] ?? "",
                              studentData['student_emails'] ?? "",
                              studentData['student_photo']);
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
                      const SizedBox(
                        width: 20,
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
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "Phone Number :",
                              style: TextStyle(
                                  fontSize:
                                      showMoreDetails ? size.width * 0.04 : 0,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(229, 230, 255, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (studentData['student_mobiles'] !=
                                            null &&
                                        (studentData['student_mobiles']
                                                as String)
                                            .isNotEmpty)
                                      ...(studentData['student_mobiles']
                                              as String)
                                          .split(',')
                                          .map((number) => Row(
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .phone_outlined, // Phone icon
                                                    size: size.width * 0.055,
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                      number.trim(),
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.width * 0.04,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons
                                                        .copy), // Copy action icon
                                                    iconSize:
                                                        size.width * 0.055,
                                                    onPressed: () {
                                                      // Handle copy action
                                                      // e.g., Clipboard.setData(ClipboardData(text: number.trim()));
                                                    },
                                                  ),
                                                  const SizedBox(width: 10),
                                                ],
                                              ))
                                          .toList()
                                    else
                                      Text(
                                        'No contact mobiles available',
                                        style: TextStyle(
                                          fontSize: size.width * 0.04,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              "E-Mail :",
                              style: TextStyle(
                                  fontSize:
                                      showMoreDetails ? size.width * 0.04 : 0,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(229, 230, 255, 1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (studentData['student_emails'] != null &&
                                      (studentData['student_emails'] as String)
                                          .isNotEmpty)
                                    ...(studentData['student_emails'] as String)
                                        .split(',')
                                        .map((email) => Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .mail_outline, // Email icon
                                                  size: size.width * 0.055,
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    email.trim(),
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.width * 0.04,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.copy),
                                                  iconSize: size.width * 0.055,
                                                  onPressed: () {},
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                            ))
                                  else
                                    Text(
                                      'No contact emails available',
                                      style: TextStyle(
                                        fontSize: size.width * 0.04,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    crossFadeState: showMoreDetails
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  IconButton(
                    onPressed: () {
                      setModalState(() {
                        showMoreDetails = !showMoreDetails;
                      });
                    },
                    icon: Icon(showMoreDetails
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
