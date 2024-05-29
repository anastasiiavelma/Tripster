import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:tripster/data/repository/profile_repository.dart';
import 'package:tripster/presentation/screens/gallery/collection_photo_widget.dart';
import 'package:tripster/presentation/screens/profile/user_info_widget.dart';
import 'package:tripster/presentation/screens/profile/user_photo_widget.dart';
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
                  return SizedBox(
                    height: 149,
                    child: Center(
                      child: SizedBox(
                          height: 10,
                          width: 10,
                          child: getCircularProgressIndicator2(context)),
                    ),
                  );
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
