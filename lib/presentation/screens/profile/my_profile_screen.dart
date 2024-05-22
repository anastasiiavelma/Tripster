import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_state.dart';
import 'package:tripster/data/repository/profile_repository.dart';
import 'package:tripster/presentation/screens/gallery/collection_photo_widget.dart';
import 'package:tripster/presentation/screens/profile/edit_profile_screen.dart';
import 'package:tripster/presentation/screens/settings/settings_screen.dart';
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
                      UserPhotoWidget(),
                      smallSizedBoxWidth,
                      Column(
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
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 800),
                            child: GestureDetector(
                              onTap: () => showModalBottomSheet(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return EditProfileScreen(
                                      profileCubit: profileCubit,
                                      userInfo: userInfo,
                                    );
                                  }),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Edit profile",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettingScreen(
                                              profileCubit: profileCubit)),
                                    ),
                                    icon: Icon(
                                      Icons.settings,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                child: Column(
                  children: [
                    CollectionWidget(profileCubit: profileCubit),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: ListOfCollectionPhotosWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        onPressed: () {
          CollectionDialog.show(context);
        },
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.background),
      ),
    );
  }
}

class UserPhotoWidget extends StatelessWidget {
  const UserPhotoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: const Image(
              image: AssetImage('assets/images/traveller.png'),
            ),
          ),
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
              child: const Icon(
                Icons.edit,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
