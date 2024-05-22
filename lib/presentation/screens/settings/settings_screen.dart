import 'package:flutter/material.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/screens/settings/settings_buttons.dart';
import 'package:tripster/presentation/widgets/custom_appbar.dart';

class SettingScreen extends StatelessWidget {
  final ProfileCubit profileCubit;
  const SettingScreen({super.key, required this.profileCubit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppBarWidget(
            title: 'Settings',
          ),
          const SliverToBoxAdapter(
              child: SizedBox(
            height: 40,
          )),
          SliverToBoxAdapter(
            child: SettingsButtonsWidget(profileCubit: profileCubit),
          ),
        ],
      ),
    );
  }
}
