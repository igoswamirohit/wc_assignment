import 'package:flutter/material.dart';

import 'constants.dart';

extension ContextExtensions on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  FocusScopeNode get focusScope => FocusScope.of(this);

  NavigatorState get navigator => Navigator.of(this);

  showSnackBar(String text, [Duration? duration]) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        text,
        style: 16.mediumStyle,
      ),
      duration: duration ?? const Duration(seconds: 1),
      backgroundColor: Colors.blue,
    ));
  }
}

extension SizedBoxCreation on num {
  Widget sizedBoxHeight() {
    return SizedBox(height: toDouble());
  }

  Widget sizedBoxWidth() {
    return SizedBox(width: toDouble());
  }

  TextStyle get semiBoldStyle => semiBold.copyWith(fontSize: toDouble());
  TextStyle get regularStyle => regular.copyWith(fontSize: toDouble());
  TextStyle get boldStyle => bold.copyWith(fontSize: toDouble());
  TextStyle get italicStyle => italic.copyWith(fontSize: toDouble());
  TextStyle get blackStyle => black.copyWith(fontSize: toDouble());
  TextStyle get mediumStyle => medium.copyWith(fontSize: toDouble());
  TextStyle get thinStyle => thin.copyWith(fontSize: toDouble());
  TextStyle get lightStyle => light.copyWith(fontSize: toDouble());
  TextStyle get extraLightStyle => extraLight.copyWith(fontSize: toDouble());
  TextStyle get extraBoldStyle => extraBold.copyWith(fontSize: toDouble());
}

extension StringExtensions on String {
  Widget richText(TextStyle style, List<TextSpan> children,
      {int? maxLines, required TextAlign textAlign}) {
    return RichText(
      maxLines: maxLines,
      textAlign: textAlign,
      text: TextSpan(
        text: this,
        style: style,
        children: children,
      ),
    );
  }

  bool get isEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,5}$').hasMatch(this);
}
