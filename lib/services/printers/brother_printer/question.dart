import 'package:image/image.dart' as img;
import 'dart:io';

class Question {
  final String data;

  Question(this.data);

  String getData() {
    return '<?xml version="1.0" encoding="UTF-8"?>\n$data';
  }
}

class GetConfig extends Question {
  GetConfig() : super('<read>\n<path>/config.xml</path>\n</read>');
}

class GetStatus extends Question {
  GetStatus() : super('<read>\n<path>/status.xml</path>\n</read>');
}

class LockQuestion extends Question {
  LockQuestion()
      : super('<lock>\n<op>set</op>\n<page_count>-1</page_count>\n<job_timeout>99</job_timeout>\n</lock>');
}


class Release extends Question {
  Release() : super('<lock>\n<op>cancel</op>\n</lock>');
}

class Print extends Question {
  Print(String mode, String cut, int dataSize, {String? jobNumber, required File imageFile})
      : super('<print>\n'
      '<mode>${mode}</mode>\n'
      '<speed>${_getModeValues(mode)['speed']}</speed>\n'
      '<lpi>${_getModeValues(mode)['lpi']}</lpi>\n'
      '<width>${_getImageWidth(imageFile)}</width>\n'
      '<height>${_getImageHeight(imageFile)}</height>\n'
      '<dataformat>jpeg</dataformat>\n'
      '<autofit>1</autofit>\n'
      '<datasize>$dataSize</datasize>\n'
      '<cutmode>$cut</cutmode>\n'
      '${jobNumber != null ? "<job_token>$jobNumber</job_token>\n" : ""}'
      '</print>');

  static Map<String, Object> _getModeValues(String mode) {
    final modes = {
      'vivid': {'name': 'vivid', 'speed': 0, 'lpi': 317},
      'normal': {'name': 'color', 'speed': 1, 'lpi': 264},
    };
    return modes[mode] ?? modes['normal']!;
  }

  static int _getImageWidth(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    return image?.width ?? 0;
  }

  static int _getImageHeight(File imageFile) {
    final image = img.decodeImage(imageFile.readAsBytesSync());
    return image?.height ?? 0;
  }
}