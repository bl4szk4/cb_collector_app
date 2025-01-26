import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../services/app_localizations.dart';
import '../widgets/navigators/go_back_navigator.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Locale) setLocale;

  const SettingsScreen({Key? key, required this.setLocale}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String printCodes = 'brother';
  String printLabels = 'brother';
  Locale currentLocale = const Locale('en');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await SettingsService.loadSettings();
      final locale = await SettingsService.loadLocale();
      setState(() {
        printCodes = settings['printCodes'] ?? 'brother';
        printLabels = settings['printLabels'] ?? 'brother';
        currentLocale = locale;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.translate('error_loading_settings')),
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
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
    widget.setLocale(locale);
    setState(() {
      currentLocale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('settings')),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
      bottomNavigationBar: GoBackNavigator(
        onTabSelected: (tab) {
          switch (tab) {
            case 'back':
              Navigator.pop(context);
              break;
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSimpleLanguageOptions() {
    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.translate('polish')),
          trailing: Radio<Locale>(
            value: const Locale('pl'),
            groupValue: currentLocale,
            onChanged: (value) => _changeLanguage(value!),
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.translate('english')),
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
          title: Text(AppLocalizations.of(context)!.translate('brother_printer')),
          leading: Radio<String>(
            value: 'brother',
            groupValue: groupValue,
            onChanged: (value) => onChanged(value!),
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.translate('internal_printer')),
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
