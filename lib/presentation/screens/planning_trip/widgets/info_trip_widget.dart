import 'package:flutter/material.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/vacation_cubit.dart';
import 'package:tripster/presentation/widgets/adress_widget.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/location_to_adress.dart';
import 'package:intl/intl.dart';

class InformationAboutTripWidget extends StatefulWidget {
  final Vacation vacation;
  final VacationCubit vacationCubit;
  final String? token;
  const InformationAboutTripWidget(
      {super.key,
      required this.vacation,
      required this.vacationCubit,
      required this.token});

  @override
  State<InformationAboutTripWidget> createState() =>
      _InformationAboutTripWidgetState();
}

class _InformationAboutTripWidgetState
    extends State<InformationAboutTripWidget> {
  void initState() {
    widget.vacationCubit
        .fetchVacation(widget.vacation.vacationId, widget.token);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dayMonthFormat = DateFormat('dd MMMM');
    final DateFormat yearFormat = DateFormat('yyyy');
    return Padding(
      padding: smallPadding,
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textAlign: TextAlign.center,
                widget.vacation.name,
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
                  AddressWidget(
                      color: kAccentColor,
                      latitude: widget.vacation.countryLat!,
                      longitude: widget.vacation.countryLon!),
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
                  Icon(Icons.date_range_outlined, color: kAccentColor),
                  smallerSizedBoxWidth,
                  Text(
                      '${yearFormat.format(widget.vacation.endDate)}, '
                      '${dayMonthFormat.format(widget.vacation.startDate)} - ${dayMonthFormat.format(widget.vacation.endDate)}',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              )),
                ],
              ),
              smallSizedBoxHeight,
              widget.vacation.fullBudget != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Budget in this trip',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontSize: 15,
                                )),
                        smallSizedBoxHeight,
                        Icon(Icons.money_outlined, color: Color(0xFF6e191d)),
                        smallerSizedBoxWidth,
                        Text(
                          '${widget.vacation.fullBudget.toString()} Dollars',
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
            ],
          ),
        ],
      ),
    );
  }
}
