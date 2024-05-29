import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tripster/domain/models/user_model.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tripster/utils/constants.dart';

class UserPhotoWidget extends StatelessWidget {
  final ProfileUser userInfo;
  final String? token;
  final ProfileCubit profileCubit;
  const UserPhotoWidget({
    super.key,
    required this.userInfo,
    required this.token,
    required this.profileCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        userInfo.avatarUrl == null || userInfo.avatarUrl!.isEmpty
            ? SizedBox(
                width: 150,
                height: 150,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: AssetImage('assets/images/traveller.png'),
                  ),
                ),
              )
            : SizedBox(
                width: 150,
                height: 150,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: checkUrl(userInfo.avatarUrl!)),
              ),
        Positioned(
          bottom: 0,
          right: 0,
          child: FadeInUp(
            duration: const Duration(milliseconds: 800),
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: kAccentColor,
              ),
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
                child: const Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget checkUrl(String url) {
    try {
      return Image.network(
        url,
        fit: BoxFit.cover,
      );
    } catch (e) {
      return Icon(Icons.image);
    }
  }
}
