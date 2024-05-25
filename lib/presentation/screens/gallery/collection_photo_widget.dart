import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/gallery_repository.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_cubit.dart';
import 'package:tripster/presentation/cubits/gallery_cubit/gallery_state.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/presentation/screens/gallery/gallery_photo_screen.dart';
import 'package:tripster/utils/constants.dart';
import 'package:intl/intl.dart';

class CollectionWidget extends StatelessWidget {
  final ProfileCubit profileCubit;
  final String? token;
  const CollectionWidget({
    super.key,
    required this.profileCubit,
    this.token,
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
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Icon(Icons.filter_list,
                color: Theme.of(context).colorScheme.onBackground),
          ],
        ));
  }
}

class ListOfCollectionPhotosWidget extends StatelessWidget {
  final GalleryRepository _galleryRepository = GalleryRepository();
  final String? token;
  ListOfCollectionPhotosWidget({
    super.key,
    this.token,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
    return BlocProvider(
      create: (context) =>
          GalleryCubit(_galleryRepository)..getUserGallery(token),
      child: BlocBuilder<GalleryCubit, GalleryState>(
        builder: (context, state) {
          if (state is GalleryLoaded) {
            final galleries = state.galleries;
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: galleries.length,
              itemBuilder: (context, index) {
                final gallery = galleries[index];
                return Padding(
                  padding: smallPadding,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PhotoGallery(gallery: gallery)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(gallery.vacation.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                    smallSizedBoxHeight,
                                    Text(
                                        '${yearFormat.format(gallery.vacation.endDate)}, '
                                        '${dayMonthFormat.format(gallery.vacation.startDate)} - ${dayMonthFormat.format(gallery.vacation.endDate)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Icon(Icons.location_on,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                    const SizedBox(height: 5),
                                    Text(gallery.vacation.countryName,
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
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: gallery.imageUrls != null &&
                                              gallery.imageUrls!.length > 1
                                          ? Image.network(
                                              gallery.imageUrls![0] as String,
                                              width: double.infinity,
                                              height: 155,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/upload.gif',
                                              width: double.infinity,
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
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: gallery.imageUrls != null &&
                                              gallery.imageUrls!.length >= 2
                                          ? Image.network(
                                              gallery.imageUrls![1] as String,
                                              width: double.infinity,
                                              height: 78,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.asset(
                                              'assets/images/no_img.jpg',
                                              width: double.infinity,
                                              height: 78,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: gallery.imageUrls != null &&
                                              gallery.imageUrls!.length >= 3
                                          ? Image.network(
                                              gallery.imageUrls![2] as String,
                                              width: double.infinity,
                                              height: 78,
                                              fit: BoxFit.fill,
                                            )
                                          : Image.asset(
                                              'assets/images/no_img.jpg',
                                              width: double.infinity,
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
              padding: const EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(kAccentColor)),
            ));
          }
        },
      ),
    );
  }
}
