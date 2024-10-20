import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SharedPreferences _prefs;
  bool _darkMode = false;
  bool _notifications = false;
  bool _locationServices = false;
  bool _showCallerId = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = _prefs.getBool('darkMode') ?? false;
      _notifications = _prefs.getBool('notifications') ?? false;
      _locationServices = _prefs.getBool('locationServices') ?? false;
      _showCallerId = _prefs.getBool('showCallerId') ?? false;
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    await _prefs.setBool(key, value);
    if (key == 'showCallerId' && value) {
      await _requestSystemAlertWindowPermission();
    }
  }

  Future<void> _requestSystemAlertWindowPermission() async {
    final status = await Permission.systemAlertWindow.request();
    if (status.isDenied) {
      // Handle the case when permission is denied
      setState(() {
        _showCallerId = false;
        _prefs.setBool('showCallerId', false);
      });
      // Optionally show a dialog to explain why the permission is needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSwitchListTile(
            title: 'Dark Mode',
            value: _darkMode,
            onChanged: (value) {
              setState(() {
                _darkMode = value;
                _savePreference('darkMode', value);
              });
            },
          ),
          _buildSwitchListTile(
            title: 'Notifications',
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
                _savePreference('notifications', value);
              });
            },
          ),
          _buildSwitchListTile(
            title: 'Location Services',
            value: _locationServices,
            onChanged: (value) {
              setState(() {
                _locationServices = value;
                _savePreference('locationServices', value);
              });
            },
          ),
          _buildSwitchListTile(
            title: 'Show Caller ID',
            value: _showCallerId,
            onChanged: (value) async {
              if (value) {
                final status = await Permission.systemAlertWindow.status;
                if (status.isDenied) {
                  await _requestSystemAlertWindowPermission();
                }
              }
              setState(() {
                _showCallerId = value;
                _savePreference('showCallerId', value);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}
