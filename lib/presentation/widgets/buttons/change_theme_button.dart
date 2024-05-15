import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripster/data/providers/theme_providers.dart';

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
      activeColor: Theme.of(context).colorScheme.background,
      activeTrackColor: Theme.of(context).colorScheme.primary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      inactiveThumbColor: Theme.of(context).colorScheme.primary,
      inactiveTrackColor: Theme.of(context).colorScheme.background,
    );
  }
}
