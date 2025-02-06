class Configuration {
  final String model;
  final double? tapeLengthInitial;
  final double? tapeWidth;

  Configuration(String xml)
      : model = _getStringXmlValue('model_name', xml) ?? 'Unknown',
        tapeLengthInitial = _getDoubleXmlValue('media_length_initial', xml),
        tapeWidth = _getDoubleXmlValue('width_inches', xml);

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