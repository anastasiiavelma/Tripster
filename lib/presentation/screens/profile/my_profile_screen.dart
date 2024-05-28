import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/domain/models/user_model.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:tripster/data/repository/profile_repository.dart';
import 'package:tripster/presentation/screens/gallery/collection_photo_widget.dart';
import 'package:tripster/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tripster/presentation/screens/profile/user_info_widget.dart';
import 'package:tripster/presentation/widgets/add_collection_dialog.dart';
import 'package:tripster/utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  final String? token;
  const ProfileScreen({Key? key, required this.token});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileCubit profileCubit;
  final ProfileRepository _profileRepository = ProfileRepository();
  @override
  void initState() {
    super.initState();
    profileCubit = ProfileCubit(_profileRepository);
    profileCubit.getUserProfile(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 55.0, 0.0, 20.0),
            child: BlocProvider(
              create: (context) => profileCubit,
              child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                if (state is ProfileLoaded) {
                  final userInfo = state.profileUser;

                  return Row(
                    children: [
                      UserPhotoWidget(
                          token: widget.token,
                          userInfo: userInfo,
                          profileCubit: profileCubit),
                      smallSizedBoxWidth,
                      smallSizedBoxWidth,
                      UserInfoWidget(
                          token: widget.token,
                          userInfo: userInfo,
                          profileCubit: profileCubit),
                    ],
                  );
                } else if (state is ProfileError) {
                  print(state.error);
                  return Center(child: Text(state.error));
                } else if ((state is ProfileLoading)) {
                  return Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kAccentColor)),
                  ));
                } else
                  return Text('smth went wrong');
              }),
            ),
          ),
          Expanded(
            child: FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Container(
                decoration: BoxDecoration(
                  color: kAccentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  child: ListOfCollectionPhotosWidget(
                    token: widget.token,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
