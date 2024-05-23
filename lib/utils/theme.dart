import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './constants.dart';

ThemeData basicTheme(bool isDarkTheme, BuildContext context) => ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: kAccentColor,
        selectionHandleColor: kBackgroundColor,
      ),
      colorScheme: isDarkTheme
          ? ColorScheme.dark(
              background: kBackgroundColor,
              onBackground: kPrimaryColor,
              primary: kPrimaryColor,
              tertiary: kAccentColor,
              secondary: kTexFieldColor,
              onSurface: kPrimaryColor,
              shadow: kBackgroundColor,
              onPrimary: kBackgroundColor,
              surface: kAccentColor,
              onError: kErrorColorDark,
            )
          : ColorScheme.light(
              background: kPrimaryColor,
              onBackground: kBackgroundColor,
              primary: kPrimaryColor,
              onSurface: kAccentColor,
              surface: kPrimaryColor,
              tertiary: kBackgroundColor,
              secondary: kTexFieldColor,
              shadow: kAccentColor,
              onPrimary: kPrimaryColor,
              onError: kErrorColorLight,
            ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.lato(
            fontSize: largeTextSize,
            color: kPrimaryColor,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold),

        titleMedium: GoogleFonts.lato(
            fontSize: mediumLargeTextSize,
            color: isDarkTheme ? kAccentColor : kBackgroundColor,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold),

        headlineLarge: GoogleFonts.lato(
            fontSize: mediumLargeTextSize,
            color: isDarkTheme ? kAccentColor : kPrimaryColor,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold),

        titleSmall: GoogleFonts.lato(
            fontSize: smallTextSize,
            color: isDarkTheme ? kAccentColor : kBackgroundColor,
            fontWeight: FontWeight.bold),

        headlineMedium: GoogleFonts.lato(
            fontSize: 16,
            color: isDarkTheme ? kAccentColor : kBackgroundColor,
            fontWeight: FontWeight.normal),

        headlineSmall: GoogleFonts.lato(
          fontSize: smallTextSize,
          color: isDarkTheme ? kAccentColor : kBackgroundColor,
        ),

        bodySmall: GoogleFonts.lato(
          fontSize: smallTextSize,
          color: isDarkTheme ? kBackgroundColor : kPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        // for textfield gray
        bodyMedium: GoogleFonts.lato(
          fontSize: mediumTextSize,
          color: kTexFieldColor,
        ),
        displaySmall: GoogleFonts.lato(
          fontSize: smallTextSize,
          color: kTexFieldColor,
        ),
        displayLarge: GoogleFonts.lato(
          fontSize: mediumTextSize,
          color: kBackgroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kBackgroundColor,
      ),
    );
