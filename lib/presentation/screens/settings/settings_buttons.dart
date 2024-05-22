import 'package:flutter/material.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/widgets/buttons/change_theme_button.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';

class SettingsButtonsWidget extends StatelessWidget {
  final ProfileCubit profileCubit;
  const SettingsButtonsWidget({super.key, required this.profileCubit});

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
                // Row(
                //   children: [
                //     Text('Language',
                //         style: Theme.of(context).textTheme.bodyMedium),
                //     spacer,
                //     // TextButton(
                //     //   onPressed: () {
                //     //     _showLanguageDialog(context);
                //     //   },
                //     //   child: Text(
                //     //       context.locale.languageCode == 'en'
                //     //           ? LocaleKeys.english.tr()
                //     //           : LocaleKeys.ukrainian.tr(),
                //     //       style: Theme.of(context).textTheme.bodyMedium),
                //     // ),
                //   ],
                // ),
                smallSizedBoxHeight,
                smallSizedBoxHeight,
                Row(children: [
                  Text('Theme',
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
                    Text('Exit',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontSize: 20)),
                    spacer,
                    TextAccentButton(
                      height: 30,
                      onTap: () {
                        profileCubit.logout(context);
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 34, vertical: 1),
                        child: Text("Log out",
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
}
