import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: Colors.transparent,
      // isDarkTheme ? Color(0xFF1E2429) : Colors.white,
      primaryColor: isDarkTheme ? Colors.black : const Color(0xffC28A6C),
      backgroundColor: isDarkTheme ? Colors.grey.shade700 : Colors.white,
      indicatorColor:
          isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
      hintColor: isDarkTheme ? Colors.grey.shade300 : Colors.grey.shade800,
      // highlightColor: isDarkTheme ? Color(0xff372901) : Color(0xffFCE192),
      hoverColor:
          isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
      focusColor:
          isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
      disabledColor: Colors.grey,
      cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
      canvasColor: isDarkTheme ? Colors.black : const Color(0xffC28A6C),
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      dividerColor: isDarkTheme ? Colors.white : Colors.black,
      textTheme: TextTheme(
          bodyText1:
              TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(elevation: 0.0, color: Color(0xffC28A6C)),
      textSelectionTheme: TextSelectionThemeData(
          selectionColor: isDarkTheme ? Colors.white : Colors.black),
      // colorScheme:
      //     ColorScheme.fromSwatch().copyWith(secondary: const Color(0xffC28A6C)),
    );
  }
}
