enum WindowType {
  desktop,
  mobile;

  String getValue() {
    switch (this) {
      case WindowType.desktop:
        return '0';
      case WindowType.mobile:
        return '1';
    }
  }
}
