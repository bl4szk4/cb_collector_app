class Lock {
  final String jobNumber;
  final String comment;

  Lock(String xml)
      : jobNumber = _getStringXmlValue('job_token', xml) ?? '',
        comment = _getStringXmlValue('comment', xml) ?? '';

  static String? _getStringXmlValue(String name, String xml) {
    final regex = RegExp('<$name>(.+?)</$name>');
    final match = regex.firstMatch(xml);
    return match?.group(1);
  }
}
