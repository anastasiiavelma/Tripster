import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/widgets/buttons/change_theme_button.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class SettingsButtonsWidget extends StatefulWidget {
  final ProfileCubit profileCubit;
  const SettingsButtonsWidget({super.key, required this.profileCubit});

  @override
  State<SettingsButtonsWidget> createState() => _SettingsButtonsWidgetState();
}

class _SettingsButtonsWidgetState extends State<SettingsButtonsWidget> {
  String selectedLanguage = LocaleKeys.en.tr();
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 900),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(LocaleKeys.language.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 20)),
                    spacer,
                    TextButton(
                      onPressed: () {
                        _showLanguageDialog(context);
                      },
                      child: Text(
                          context.locale.languageCode == 'en'
                              ? LocaleKeys.en.tr()
                              : LocaleKeys.ukr.tr(),
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  ],
                ),
                smallSizedBoxHeight,
                Row(children: [
                  Text(LocaleKeys.dark_theme.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 20)),
                  spacer,
                  ThemeButton(),
                ]),
                smallSizedBoxHeight,
                smallSizedBoxHeight,
                Row(
                  children: [
                    Text(LocaleKeys.exit.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 20)),
                    spacer,
                    TextAccentButton(
                      height: 30,
                      onTap: () {
                        widget.profileCubit.logout(context);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 34, vertical: 1),
                        child: Text(LocaleKeys.logout.tr(),
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> _showLanguageDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Select Language',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () async {
                  context.setLocale(const Locale('en'));
                  setState(() {
                    selectedLanguage = LocaleKeys.en.tr();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  LocaleKeys.en.tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              TextButton(
                onPressed: () async {
                  context.setLocale(const Locale('uk'));
                  setState(() {
                    selectedLanguage = LocaleKeys.ukr.tr();
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  LocaleKeys.ukr.tr(),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
