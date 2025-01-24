enum LabelType {
  QR_CODE, // 1
  SPECIFICATION, // 2
  QR_CODE_SPECIFICATION, // 3
  MULTIPLE_LABELS // 4
}

extension LabelTypeExtension on LabelType {
  int get value {
    switch (this) {
      case LabelType.QR_CODE:
        return 1;
      case LabelType.SPECIFICATION:
        return 2;
      case LabelType.QR_CODE_SPECIFICATION:
        return 3;
      case LabelType.MULTIPLE_LABELS:
        return 4;
    }
  }
}