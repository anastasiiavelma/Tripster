import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/data/cubits/profile_cubit/profile_state.dart';
import 'package:tripster/presentation/screens/home/home_screen.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/presentation/widgets/buttons/change_theme_button.dart';

class HeaderProfileWidget extends StatefulWidget {
  final String? token;
  final String? userId;
  const HeaderProfileWidget({
    super.key,
    this.token,
    this.userId,
  });

  @override
  State<HeaderProfileWidget> createState() => _HeaderProfileWidgetState();
}

class _HeaderProfileWidgetState extends State<HeaderProfileWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserProfile(widget.token!);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
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
                          image: AssetImage('assets/images/traveller.png'),
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
                          ThemeButton(),
                          IconButton(
                            onPressed: () {},
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
              ),
            ],
          );
        } else if (state is ProfileError) {
          print(state.error);
          return Center(child: Text(state.error));
        } else {
          return Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kAccentColor)),
          ));
        }
      }),
    );
  }
}
