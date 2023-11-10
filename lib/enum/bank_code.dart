// ignore_for_file: constant_identifier_names

enum BankCode {
  MOMO,
  ZALO,
  VTTP,
  // empty for this case
  EMPTY;

  String get codeValue {
    switch (this) {
      case BankCode.EMPTY:
        return '';
      default:
        return name;
    }
  }
}
