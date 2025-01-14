import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String printCodes = 'brother';
  String printLabels = 'brother';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.loadSettings();
    setState(() {
      printCodes = settings['printCodes']!;
      printLabels = settings['printLabels']!;
    });
  }

  Future<void> _updateSetting(String key, String value) async {
    await SettingsService.saveSetting(key, value);
    setState(() {
      if (key == 'printCodes') {
        printCodes = value;
      } else if (key == 'printLabels') {
        printLabels = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingOption(
              title: AppLocalizations.of(context)!.translate('print_codes'),
              groupValue: printCodes,
              onChanged: (value) => _updateSetting('printCodes', value),
            ),
            const SizedBox(height: 16),
            _buildSettingOption(
              title: AppLocalizations.of(context)!.translate('print_labels'),
              groupValue: printLabels,
              onChanged: (value) => _updateSetting('printLabels', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String title,
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
        )),
        ListTile(
          title: const Text('Brother Printer'),
          leading: Radio<String>(
            value: 'brother',
            groupValue: groupValue,
            onChanged: (value) => onChanged(value!),
          ),
        ),
        ListTile(
          title: const Text('Internal Printer'),
          leading: Radio<String>(
            value: 'internal',
            groupValue: groupValue,
            onChanged: (value) => onChanged(value!),
          ),
        ),
      ],
    );
  }
}
