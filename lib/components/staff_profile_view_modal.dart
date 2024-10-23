import 'package:ajce_staff_contacts/hive/dept_crud_operations.dart';
import 'package:ajce_staff_contacts/provider/favorites_provider.dart';
import 'package:ajce_staff_contacts/components/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

Future<dynamic> StaffProfileView(BuildContext context, List staffData) {
  Size size = MediaQuery.of(context).size;
  return showModalBottomSheet(
    isDismissible: true,
    enableDrag: false, // Disable dragging
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
      final isFavorite = Provider.of<FavoritesProvider>(context, listen: true)
          .isFavorite(staffData[0]['staffCode']);
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          // Function to handle copy action
          void handleCopy(String text) {
            Clipboard.setData(ClipboardData(text: text));
            Fluttertoast.showToast(
                msg: "Copied to clipboard",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey[600],
                textColor: Colors.white,
                fontSize: 16.0);
          }

          return GestureDetector(
            onTap: () {}, // Prevent taps from dismissing the modal
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
                                  imageUrl: staffData[0]['photo'] ?? "",
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Text(
                                        staffData[0]['staffName'][0]
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: Text(
                                        staffData[0]['staffName'][0]
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${staffData[0]['staffName']}",
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
                            "${staffData[0]['designation']} (${DeptCrudOperations().getDepartmentByCode(staffData[0]['deptCode'])?['deptshort'] ?? 'Unknown Department'})",
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
                              if (staffData[0]['contact_mobiles'] != null &&
                                  staffData[0]['contact_mobiles'].isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    final List<String> phoneNumbers =
                                        staffData[0]['contact_mobiles']
                                            .split(',');
                                    if (phoneNumbers.length != 1) {
                                      showDialog(
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
                                                    onTap: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      await FlutterPhoneDirectCaller
                                                          .callNumber(
                                                              "+$phone");
                                                    },
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
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        const Icon(Icons
                                                            .phone_outlined)
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      await FlutterPhoneDirectCaller.callNumber(
                                          "+${phoneNumbers[0]}");
                                    }
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
                              if (staffData[0]['contact_mobiles'] != null &&
                                  staffData[0]['contact_mobiles'].isNotEmpty)
                                const SizedBox(width: 20),
                              if (staffData[0]['contact_mobiles'] != null &&
                                  staffData[0]['contact_mobiles'].isNotEmpty)
                                GestureDetector(
                                  onTap: () => UrlLauncher().whatsappUrl(
                                      staffData[0]['contact_mobiles'], context),
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
                              if (staffData[0]['contact_emails'] != null &&
                                  staffData[0]['contact_emails'].isNotEmpty)
                                const SizedBox(width: 20),
                              if (staffData[0]['contact_emails'] != null &&
                                  staffData[0]['contact_emails'].isNotEmpty)
                                GestureDetector(
                                  onTap: () async {
                                    final List<String> mailId = staffData[0]
                                            ['contact_emails']
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
                                                                .mailUrl(mail),
                                                        child: GestureDetector(
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
                                        : UrlLauncher().mailUrl(
                                            staffData[0]['contact_emails']);
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
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  UrlLauncher().shareContent(
                                      staffData[0]['staffName'],
                                      staffData[0]['contact_mobiles'] ?? "",
                                      staffData[0]['contact_emails'] ?? "",
                                      staffData[0]['photo']);
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
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromRGBO(229, 230, 255, 1),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isFavorite ? Colors.red : null,
                                    ),
                                    onPressed: () {
                                      if (isFavorite) {
                                        Provider.of<FavoritesProvider>(context,
                                                listen: false)
                                            .removeFavorite(
                                                staffData[0]['staffCode']);
                                      } else {
                                        Provider.of<FavoritesProvider>(context,
                                                listen: false)
                                            .addFavorite(
                                                staffData[0]['staffCode']);
                                      }
                                    },
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
                                          if (staffData[0]['contact_mobiles'] !=
                                                  null &&
                                              (staffData[0]['contact_mobiles']
                                                      as String)
                                                  .isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Phone:",
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                ...(staffData[0]
                                                            ['contact_mobiles']
                                                        as String)
                                                    .split(',')
                                                    .map((number) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 2),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .phone_outlined,
                                                                size:
                                                                    size.width *
                                                                        0.04,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  number.trim(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        size.width *
                                                                            0.035,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                    Icons.copy,
                                                                    size: size
                                                                            .width *
                                                                        0.04),
                                                                onPressed: () =>
                                                                    handleCopy(
                                                                        number
                                                                            .trim()),
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                constraints:
                                                                    BoxConstraints(),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                    .toList(),
                                              ],
                                            ),
                                          if (staffData[0]['contact_emails'] !=
                                                  null &&
                                              (staffData[0]['contact_emails']
                                                      as String)
                                                  .isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 10),
                                                Text(
                                                  "Email:",
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * 0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 5),
                                                ...(staffData[0]
                                                            ['contact_emails']
                                                        as String)
                                                    .split(',')
                                                    .map((email) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 2),
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .mail_outline,
                                                                size:
                                                                    size.width *
                                                                        0.04,
                                                              ),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Expanded(
                                                                child: Text(
                                                                  email.trim(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        size.width *
                                                                            0.035,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: Icon(
                                                                    Icons.copy,
                                                                    size: size
                                                                            .width *
                                                                        0.04),
                                                                onPressed: () =>
                                                                    handleCopy(email
                                                                        .trim()),
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                constraints:
                                                                    BoxConstraints(),
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                    .toList(),
                                              ],
                                            ),
                                          if (staffData[0]['contact_mobiles'] ==
                                                  null &&
                                              staffData[0]['contact_emails'] ==
                                                  null)
                                            Text(
                                              'No contact information available',
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
