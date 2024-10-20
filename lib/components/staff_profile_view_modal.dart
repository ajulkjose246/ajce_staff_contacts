import 'package:ajce_staff_contacts/hive/dept_crud_operations.dart';
import 'package:ajce_staff_contacts/provider/favorites_provider.dart';
import 'package:ajce_staff_contacts/components/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

Future<dynamic> StaffProfileView(BuildContext context, List staffData) {
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
      final isFavorite = Provider.of<FavoritesProvider>(context, listen: true)
          .isFavorite(staffData[0]['staffCode']);
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
                          imageUrl: staffData[0]['photo'] ?? "",
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      staffData[0]['contact_mobiles'] != null
                          ? GestureDetector(
                              onTap: () async {
                                final List<String> phoneNumbers =
                                    staffData[0]['contact_mobiles'].split(',');
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
                                            children: phoneNumbers.map((phone) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  Navigator.of(context).pop();
                                                  await FlutterPhoneDirectCaller
                                                      .callNumber("+$phone");
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "+$phone",
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const Icon(
                                                        Icons.phone_outlined)
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
                            )
                          : Container(),
                      const SizedBox(
                        width: 20,
                      ),
                      staffData[0]['contact_mobiles'] != null
                          ? GestureDetector(
                              onTap: () => UrlLauncher()
                                  .whatsappUrl(staffData[0]['contact_mobiles']),
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
                      staffData[0]['contact_emails'] != null
                          ? GestureDetector(
                              onTap: () async {
                                final List<String> mailId =
                                    staffData[0]['contact_emails'].split(',');
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
                            )
                          : Container(),
                      const SizedBox(
                        width: 20,
                      ),
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
                      const SizedBox(
                        width: 20,
                      ),
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
                                    .removeFavorite(staffData[0]['staffCode']);
                              } else {
                                Provider.of<FavoritesProvider>(context,
                                        listen: false)
                                    .addFavorite(staffData[0]['staffCode']);
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
                                    if (staffData[0]['contact_mobiles'] !=
                                            null &&
                                        (staffData[0]['contact_mobiles']
                                                as String)
                                            .isNotEmpty)
                                      ...(staffData[0]['contact_mobiles']
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
                                  if (staffData[0]['contact_emails'] != null &&
                                      (staffData[0]['contact_emails'] as String)
                                          .isNotEmpty)
                                    ...(staffData[0]['contact_emails']
                                            as String)
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
