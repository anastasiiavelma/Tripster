import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/screens/settings/settings_buttons.dart';
import 'package:tripster/presentation/widgets/headers/custom_appbar.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class SettingScreen extends StatefulWidget {
  final ProfileCubit profileCubit;
  const SettingScreen({super.key, required this.profileCubit});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBarWidget(
            title: LocaleKeys.settings.tr(),
          ),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 40,
          )),
          SliverToBoxAdapter(
            child: SettingsButtonsWidget(profileCubit: widget.profileCubit),
          ),
        ],
      ),
    );
  }
}
