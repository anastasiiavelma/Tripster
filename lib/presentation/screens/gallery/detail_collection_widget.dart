import 'package:flutter/material.dart';
import 'package:tripster/domain/models/gallery_model.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/utils/constants.dart';
import 'package:intl/intl.dart';

class DetailCollectionWidget extends StatelessWidget {
  const DetailCollectionWidget({
    super.key,
    required this.vacation,
    required this.yearFormat,
    required this.dayMonthFormat,
    required this.gallery,
  });

  final Vacation vacation;
  final DateFormat yearFormat;
  final DateFormat dayMonthFormat;
  final Gallery gallery;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: smallPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vacation.name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    smallSizedBoxHeight,
                    Text(
                        '${yearFormat.format(vacation.endDate)}, '
                        '${dayMonthFormat.format(vacation.startDate)} - ${dayMonthFormat.format(vacation.endDate)}',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Icon(Icons.location_on,
                        color: Theme.of(context).colorScheme.onBackground),
                    const SizedBox(height: 5),
                    Text(vacation.countryName,
                        style: Theme.of(context).textTheme.headlineSmall),
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
    );
  }
}
