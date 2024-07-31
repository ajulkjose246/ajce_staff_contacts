// ignore_for_file: use_build_context_synchronously

import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:phone_state/phone_state.dart';
import 'package:system_alert_window/system_alert_window.dart';

class UtilityPage extends StatefulWidget {
  const UtilityPage({Key? key}) : super(key: key);

  @override
  State<UtilityPage> createState() => _UtilityPageState();
}

class _UtilityPageState extends State<UtilityPage> {
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
          _showOverlayWindow();
          print(event.number);
          setState(() {});
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

  void _showOverlayWindow() async {
    if (!_isShowingWindow) {
      await SystemAlertWindow.sendMessageToOverlay('show system window');
      SystemAlertWindow.showSystemWindow(
          height: 200,
          width: MediaQuery.of(context).size.width.floor(),
          gravity: SystemWindowGravity.CENTER,
          prefMode: prefMode);
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
    return Center(
        child: Column(
      children: [
        ElevatedButton(
            onPressed: () {
              _showOverlayWindow();
            },
            child: Text("d")),
        ElevatedButton(
            onPressed: () {
              _hideOverlayWindow();
            },
            child: Text("d")),
      ],
    ));
  }
}
