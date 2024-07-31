import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:phone_state/phone_state.dart';
import 'package:system_alert_window/system_alert_window.dart';

class TrueCallerOverlay extends StatefulWidget {
  const TrueCallerOverlay({Key? key}) : super(key: key);

  @override
  State<TrueCallerOverlay> createState() => _TrueCallerOverlayState();
}

class _TrueCallerOverlayState extends State<TrueCallerOverlay> {
  bool isGold = true;

  // String phoneNumber = '';

  final _goldColors = const [
    Color(0xFFa2790d),
    Color(0xFFebd197),
    Color(0xFFa2790d),
  ];

  final _silverColors = const [
    Color(0xFFAEB2B8),
    Color(0xFFC7C9CB),
    Color(0xFFD7D7D8),
    Color(0xFFAEB2B8),
  ];
  bool _isShowingWindow = false;
  SystemWindowPrefMode prefMode = SystemWindowPrefMode.OVERLAY;
  SendPort? homePort;
  String? latestMessageFromOverlay;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _listenPhoneState();
  }

  void _listenPhoneState() {
    PhoneState.stream.listen((event) {
      switch (event.status) {
        case PhoneStateStatus.CALL_INCOMING:
        case PhoneStateStatus.CALL_STARTED:
          _showOverlayWindow(event.number);
          break;
        case PhoneStateStatus.CALL_ENDED:
          _hideOverlayWindow();
          break;
        case PhoneStateStatus.NOTHING:
          break;
      }
    });
  }

  @override
  void dispose() {
    SystemAlertWindow.removeOnClickListener();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    await SystemAlertWindow.requestPermissions(prefMode: prefMode);
  }

  void _showOverlayWindow(String? phoneNumber) async {
    if (!_isShowingWindow) {
      await SystemAlertWindow.sendMessageToOverlay('show system window');
      SystemAlertWindow.showSystemWindow(
        height: 200,
        width: MediaQuery.of(context).size.width.floor(),
        gravity: SystemWindowGravity.CENTER,
        prefMode: prefMode,
      );
      setState(() {
        _isShowingWindow = true;
      });
    }
  }

  void _hideOverlayWindow() async {
    if (_isShowingWindow) {
      setState(() {
        _isShowingWindow = false;
      });
      await SystemAlertWindow.closeSystemWindow(prefMode: prefMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isGold ? _goldColors : _silverColors,
            ),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: GestureDetector(
            onTap: () {
              setState(() {
                isGold = !isGold;
              });
              // FlutterOverlayWindow.getOverlayPosition().then((value) {
              //   log("Overlay Position: $value");
              // });
            },
            child: Stack(
              children: [
                Column(
                  children: [
                    ListTile(
                      leading: Container(
                        height: 80.0,
                        width: 80.0,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: NetworkImage(
                                "https://api.multiavatar.com/x-slayer.png"),
                          ),
                        ),
                      ),
                      title: const Text(
                        "X-SLAYER",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text("Sousse , Tunisia"),
                    ),
                    const Spacer(),
                    const Divider(color: Colors.black54),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("phoneNumber"),
                              Text("Last call - 1 min ago"),
                            ],
                          ),
                          Text(
                            "Flutter Overlay",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () async {
                      // await FlutterOverlayWindow.closeOverlay();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
