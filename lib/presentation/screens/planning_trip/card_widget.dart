import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/screens/home/maps.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class CardWidget extends StatelessWidget {
  final Vacation vacation;
  const CardWidget({
    super.key,
    required this.vacation,
  });

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
    return Padding(
      padding: smallerPadding,
      child: Card(
        color: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            alignment: Alignment.topCenter,
            width: 120,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Maps(
                      latitude: vacation.countryLat!,
                      longitude: vacation.countryLon!,
                    ),
                  ),
                ),
                smallSizedBoxHeight,
                Text(
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  vacation.name,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Theme.of(context).colorScheme.background,
                      ),
                ),
                smallSizedBoxHeight,
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Theme.of(context).colorScheme.background,
                    ),
                    smallerSizedBoxWidth,
                    Text(
                      vacation.countryName,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                smallSizedBoxHeight,
                Row(
                  children: [
                    Icon(Icons.date_range_outlined,
                        color: Theme.of(context).colorScheme.background),
                    smallerSizedBoxWidth,
                    Text(
                        '${yearFormat.format(vacation.endDate)}, '
                        '${dayMonthFormat.format(vacation.startDate)} - ${dayMonthFormat.format(vacation.endDate)}',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
                smallSizedBoxHeight,
                vacation.fullBudget != null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.money_outlined, color: Color(0xFF6e191d)),
                          smallerSizedBoxWidth,
                          Text(
                            '${vacation.fullBudget.toString()} ${LocaleKeys.dollars.tr()}',
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(color: Color(0xFF6e191d)),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 1,
                      ),
                smallSizedBoxHeight,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
