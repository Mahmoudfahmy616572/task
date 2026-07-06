import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }

  Size get screenSize => MediaQuery.sizeOf(this);

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;
}
