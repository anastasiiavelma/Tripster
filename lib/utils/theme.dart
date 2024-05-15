import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './constants.dart';

ThemeData basicTheme(bool isDarkTheme, BuildContext context) => ThemeData(
      colorScheme: isDarkTheme
          ? ColorScheme.dark(
              //background
              background: kBackgroundColor,
              onBackground: kPrimaryColor,
              primary: kPrimaryColor,
              tertiary: kAccentColor,
              secondary: kTexFieldColor,
              onSurface: kPrimaryColor,
              shadow: kBackgroundColor,
              onPrimary: kBackgroundColor,
              surface: kAccentColor,
              //for red budget
              onError: kErrorColorDark,
            )
          : ColorScheme.light(
              //background
              background: kPrimaryColor,
              onBackground: kBackgroundColor,
              primary: kPrimaryColor,
              onSurface: kAccentColor,
              surface: kPrimaryColor,
              tertiary: kBackgroundColor,
              secondary: kTexFieldColor,
              shadow: kAccentColor,
              onPrimary: kPrimaryColor,

              //for red budget
              onError: kErrorColorLight,
            ),
      textTheme: TextTheme(
        //for title 'register' and 'login' white
        titleLarge: GoogleFonts.lato(
            fontSize: largeTextSize,
            color: kPrimaryColor,
            letterSpacing: 1.0,
            fontWeight: FontWeight.bold),
        //for title 'lets discover'  white
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

        // for BOLD mini-title 'sign up' and 'sign in'
        titleSmall: GoogleFonts.lato(
            fontSize: smallTextSize,
            color: isDarkTheme ? kAccentColor : kBackgroundColor,
            fontWeight: FontWeight.bold),

        headlineMedium: GoogleFonts.lato(
            fontSize: 10,
            color: isDarkTheme ? kAccentColor : kBackgroundColor,
            fontWeight: FontWeight.bold),
        //for text button PINK
        headlineSmall: GoogleFonts.lato(
          fontSize: smallTextSize,
          color: isDarkTheme ? kAccentColor : kBackgroundColor,
        ),
        // for text button dark
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
