class Status {
  final String printState;
  final String printJobStage;
  final String printJobError;
  final double? tapeLengthRemaining;

  Status(String xml)
      : printState = _getStringXmlValue('print_state', xml) ?? 'Unknown',
        printJobStage = _getStringXmlValue('print_job_stage', xml) ?? 'Unknown',
        printJobError = _getStringXmlValue('print_job_error', xml) ?? 'Unknown',
        tapeLengthRemaining = _getDoubleXmlValue('remain', xml);

  static String? _getStringXmlValue(String name, String xml) {
    final regex = RegExp('<$name>(.+?)</$name>');
    final match = regex.firstMatch(xml);
    return match?.group(1);
  }

  static double? _getDoubleXmlValue(String name, String xml) {
    final value = _getStringXmlValue(name, xml);
    return value != null ? double.tryParse(value) : null;
  }
}