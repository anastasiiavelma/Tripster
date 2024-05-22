import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripster/presentation/providers/theme_providers.dart';
import 'package:tripster/utils/constants.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Switch(
      value: themeChange.darkTheme,
      onChanged: (bool newValue) {
        themeChange.darkTheme = newValue;
      },
      activeColor: Theme.of(context).colorScheme.primary,
      activeTrackColor: Theme.of(context).colorScheme.tertiary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      inactiveThumbColor: kAccentColor,
      inactiveTrackColor: Theme.of(context).colorScheme.background,
    );
  }
}
