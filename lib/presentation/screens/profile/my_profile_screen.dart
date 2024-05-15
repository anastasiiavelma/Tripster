import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/data/cubits/profile_cubit/profile_state.dart';
import 'package:tripster/presentation/screens/home/home_screen.dart';
import 'package:tripster/presentation/screens/profile/header_info.dart';
import 'package:tripster/presentation/widgets/add_collection_dialog.dart';
import 'package:tripster/presentation/screens/profile/gallery_photo_screen.dart';
import 'package:tripster/presentation/widgets/buttons/change_theme_button.dart';
import 'package:tripster/utils/constants.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class ProfileScreen extends StatefulWidget {
  final String? token;
  const ProfileScreen({Key? key, required this.token});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<String> collections = [
    'Weekend 2023',
    'Weekend 2024',
  ];

  List<String> location = [
    'Ireland',
    'Island',
  ];

  List<String> dates = [
    '24 June - 25 September',
    '24 June - 25 September',
  ];

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
              create: (context) => ProfileCubit()..getUserProfile(widget.token),
              child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Row(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: const Image(
                                  image:
                                      AssetImage('assets/images/traveller.png'),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 1600),
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
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInUp(
                            duration: const Duration(milliseconds: 1900),
                            child: Text(
                              state.profileUser.name,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1900),
                            child: Text(
                              state.profileUser.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          const SizedBox(height: 20),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1900),
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              ),
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
                                  ThemeButton(),
                                  IconButton(
                                    onPressed: () {},
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
              duration: const Duration(milliseconds: 1900),
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
                    SettingWidget(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: ListOfCollectionPhotosWidget(
                          collections: collections,
                          location: location,
                          dates: dates),
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

class SettingWidget extends StatelessWidget {
  const SettingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.sort, color: Theme.of(context).colorScheme.onBackground),
            Text(
              'My collections',
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: mediumLargeTextSize,
              ),
            ),
            Icon(Icons.filter_list,
                color: Theme.of(context).colorScheme.onBackground),
          ],
        ));
  }
}

class ListOfCollectionPhotosWidget extends StatelessWidget {
  const ListOfCollectionPhotosWidget({
    super.key,
    required this.collections,
    required this.location,
    required this.dates,
  });

  final List<String> collections;
  final List<String> location;
  final List<String> dates;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: collections.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(20.0)),
            child: ListTile(
              leading: const Icon(Ionicons.airplane),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                    width: 45,
                    child: Icon(Icons.location_on,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  const SizedBox(height: 2),
                  Text(location[index],
                      style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
              subtitle: Text(dates[index],
                  style: Theme.of(context).textTheme.displaySmall),
              title: Text(collections[index],
                  style: Theme.of(context).textTheme.headlineSmall),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PhotoGallery(collectionName: collections[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
