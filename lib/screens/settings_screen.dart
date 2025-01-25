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
  Locale currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.loadSettings();
    final locale = await SettingsService.loadLocale();
    setState(() {
      printCodes = settings['printCodes']!;
      printLabels = settings['printLabels']!;
      currentLocale = locale;
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

  Future<void> _changeLanguage(Locale locale) async {
    await SettingsService.saveLocale(locale);
    setState(() {
      currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(AppLocalizations.of(context)!.translate('language')),
            const SizedBox(height: 8),
            _buildSimpleLanguageOptions(),
            const Divider(height: 32),
            _buildSectionTitle(AppLocalizations.of(context)!.translate('print_codes')),
            const SizedBox(height: 8),
            _buildSettingOption(
              groupValue: printCodes,
              onChanged: (value) => _updateSetting('printCodes', value),
            ),
            const Divider(height: 32),
            _buildSectionTitle(AppLocalizations.of(context)!.translate('print_labels')),
            const SizedBox(height: 8),
            _buildSettingOption(
              groupValue: printLabels,
              onChanged: (value) => _updateSetting('printLabels', value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSimpleLanguageOptions() {
    return Column(
      children: [
        ListTile(
          title: const Text('Polski'),
          trailing: Radio<Locale>(
            value: const Locale('pl'),
            groupValue: currentLocale,
            onChanged: (value) => _changeLanguage(value!),
          ),
        ),
        ListTile(
          title: const Text('English'),
          trailing: Radio<Locale>(
            value: const Locale('en'),
            groupValue: currentLocale,
            onChanged: (value) => _changeLanguage(value!),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingOption({
    required String groupValue,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      children: [
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
