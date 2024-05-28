import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/gallery_repository.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_cubit.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_state.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/vacation_cubit.dart';
import 'package:tripster/presentation/screens/gallery/gallery_photo_screen.dart';
import 'package:tripster/presentation/widgets/add_collection_dialog.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/utils/constants.dart';
import 'package:intl/intl.dart';

class ListOfCollectionPhotosWidget extends StatelessWidget {
  final GalleryRepository _galleryRepository = GalleryRepository();
  final String? token;
  final List<Vacation>? vacations;
  ListOfCollectionPhotosWidget({
    super.key,
    this.vacations,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final galleryCubit = GalleryCubit(_galleryRepository);
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => galleryCubit..getUserGallery(token),
          ),
          BlocProvider(
            create: (context) =>
                VacationCubit(VacationRepository())..fetchUserVacations(token),
          ),
        ],
        child: BlocBuilder<VacationCubit, VacationState>(
          builder: (context, state) {
            if (state is VacationLoading) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: getCircularProgressIndicator2(context),
              );
            } else if (state is VacationsLoaded) {
              final vacations = state.vacations;

              return Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.sort,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                          Text(
                            'My collections',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Icon(Icons.filter_list,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ],
                      )),
                  smallSizedBoxHeight,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextAccentButton(
                      height: 40,
                      color: Theme.of(context).colorScheme.background,
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          isScrollControlled: true,
                          builder: (context) => CollectionDialog(
                            token: token,
                            vacations1: vacations,
                            galleryCubit: galleryCubit,
                          ),
                        );
                      },
                      child: Text('Create photo collection',
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<GalleryCubit, GalleryState>(
                      builder: (context, state) {
                        if (state is GalleryLoaded) {
                          final galleries = state.galleries;
                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: galleries.length,
                            itemBuilder: (context, index) {
                              final gallery = galleries[index];
                              print(gallery.imageUrls);
                              return Padding(
                                padding: smallPadding,
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PhotoGallery(
                                            gallery: gallery,
                                            vacation: vacations[index])),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(6.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(vacations[index].name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                  smallSizedBoxHeight,
                                                  Text(
                                                      '${yearFormat.format(vacations[index].endDate)}, '
                                                      '${dayMonthFormat.format(vacations[index].startDate)} - ${dayMonthFormat.format(vacations[index].endDate)}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall),
                                                ],
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Icon(Icons.location_on,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onBackground),
                                                  const SizedBox(height: 5),
                                                  Text(
                                                      vacations[index]
                                                          .countryName,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        smallSizedBoxHeight,
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: gallery.imageUrls !=
                                                                null &&
                                                            gallery.imageUrls!
                                                                    .length >
                                                                1
                                                        ? Image.network(
                                                            gallery
                                                                .imageUrls![0],
                                                            width:
                                                                double.infinity,
                                                            height: 155,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/upload.gif',
                                                            width:
                                                                double.infinity,
                                                            height: 155,
                                                            fit: BoxFit.cover,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: gallery.imageUrls !=
                                                                null &&
                                                            gallery.imageUrls!
                                                                    .length >=
                                                                2
                                                        ? Image.network(
                                                            gallery
                                                                .imageUrls![1],
                                                            width:
                                                                double.infinity,
                                                            height: 78,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/no_img.jpg',
                                                            width:
                                                                double.infinity,
                                                            height: 78,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: gallery.imageUrls !=
                                                                null &&
                                                            gallery.imageUrls!
                                                                    .length >=
                                                                3
                                                        ? Image.network(
                                                            gallery
                                                                .imageUrls![2],
                                                            width:
                                                                double.infinity,
                                                            height: 78,
                                                            fit: BoxFit.fill,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/no_img.jpg',
                                                            width:
                                                                double.infinity,
                                                            height: 78,
                                                            fit: BoxFit.fill,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state is GalleryError) {
                          print(state.error);
                          return Center(child: Text(state.error));
                        } else {
                          return Center(
                            child: Padding(
                                padding: const EdgeInsets.only(top: 90),
                                child: getCircularProgressIndicator2(context)),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            } else if (state is VacationError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('No vacations found.'));
            }
          },
        ),
      ),
    );
  }
}
