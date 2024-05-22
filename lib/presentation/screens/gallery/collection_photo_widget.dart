import 'package:flutter/material.dart';
import 'package:tripster/presentation/cubits/profile_cubit/profile_cubit.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/presentation/screens/gallery/gallery_photo_screen.dart';
import 'package:tripster/utils/constants.dart';
import 'package:intl/intl.dart';

class CollectionWidget extends StatelessWidget {
  final ProfileCubit profileCubit;
  const CollectionWidget({
    super.key,
    required this.profileCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.sort, color: Theme.of(context).colorScheme.onBackground),
            TextButton(
              onPressed: () {
                profileCubit.logout(context);
                Navigator.of(context).pop();
              },
              child: Text("Выйти"),
            ),
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
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
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
                                    ?.copyWith(fontWeight: FontWeight.bold)),
                            smallSizedBoxHeight,
                            Text(
                                '${yearFormat.format(gallery.vacation.dateEnd)}, '
                                '${dayMonthFormat.format(gallery.vacation.dateStart)} - ${dayMonthFormat.format(gallery.vacation.dateEnd)}',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.location_on,
                                color:
                                    Theme.of(context).colorScheme.onBackground),
                            const SizedBox(height: 5),
                            Text(gallery.vacation.location,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
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
                                      gallery.imageUrls![0],
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
                                      gallery.imageUrls![1],
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
                                      gallery.imageUrls![2],
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
  }
}
