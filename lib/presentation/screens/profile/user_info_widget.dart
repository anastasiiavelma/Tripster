import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tripster/domain/models/user_model.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tripster/presentation/screens/settings/settings_screen.dart';

class UserInfoWidget extends StatelessWidget {
  final String? token;
  const UserInfoWidget({
    super.key,
    required this.userInfo,
    required this.profileCubit,
    required this.token,
  });

  final ProfileUser userInfo;
  final ProfileCubit profileCubit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width / 2,
          child: FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Text(
              maxLines: 1,
              userInfo.name,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        SizedBox(
          child: FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Text(
              userInfo.email,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          duration: const Duration(milliseconds: 800),
          child: GestureDetector(
            onTap: () => showModalBottomSheet(
                backgroundColor: Theme.of(context).colorScheme.background,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return EditProfileScreen(
                    token: token,
                    profileCubit: profileCubit,
                    userInfo: userInfo,
                  );
                }),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Edit profile",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SettingScreen(profileCubit: profileCubit)),
                  ),
                  icon: Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
