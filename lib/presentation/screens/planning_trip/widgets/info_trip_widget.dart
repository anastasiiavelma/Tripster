import 'package:flutter/material.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/utils/constants.dart';

class InformationAboutTripWidget extends StatelessWidget {
  final Vacation vacation;
  const InformationAboutTripWidget({super.key, required this.vacation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: smallPadding,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.center,
                vacation.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 24.0),
              ),
              smallSizedBoxHeight,
              Text('Location',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 15)),
              smallSizedBoxHeight,
              Row(
                children: [
                  Icon(Icons.location_on,
                      color: Theme.of(context).colorScheme.onBackground),
                  Text(
                    vacation.location,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              smallSizedBoxHeight,
              Text('Information about trip',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 15,
                      )),
              smallSizedBoxHeight,
              Row(
                children: [
                  Icon(Icons.date_range_outlined,
                      color: Theme.of(context).colorScheme.onBackground),
                  smallerSizedBoxWidth,
                  Text(
                    vacation.dateStart.toString().substring(0, 10),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 15.0, fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    ' — ',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    vacation.dateEnd.toString().substring(0, 10),
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontWeight: FontWeight.normal),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              smallSizedBoxHeight,
              Text('Budget in this trip',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 15,
                      )),
              smallSizedBoxHeight,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.money_outlined,
                      color: Theme.of(context).colorScheme.onError),
                  smallerSizedBoxWidth,
                  Text(
                    '${vacation.fullBudget.toString()} Dollars',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onError),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
