import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/data/repository/vacation_repository.dart';
import 'package:tripster/presentation/cubits/vacation_cubit/vacation_cubit.dart';
import 'package:tripster/presentation/widgets/custom_search_widget.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

import 'plan_trip_list_widget.dart';

class PlanTripScreen extends StatefulWidget {
  final String? token;
  const PlanTripScreen({super.key, this.token});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  late final VacationCubit vacationCubit;
  final VacationRepository _vacationRepository = VacationRepository();
  bool sortByNewest = false;
  String searchQuery = '';
  @override
  void initState() {
    vacationCubit = VacationCubit(_vacationRepository);
    vacationCubit.fetchUserVacations(widget.token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.11,
            floating: true,
            pinned: false,
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            surfaceTintColor: Theme.of(context).colorScheme.background,
            flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.only(
                  left: 0,
                  top: constraints.maxHeight - 70,
                  bottom: 10,
                ),
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.my_trips.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                              fontSize: 22,
                              color: Theme.of(context).colorScheme.background,
                              fontWeight: FontWeight.bold),
                    ),
                    smallSizedBoxHeight,
                  ],
                ),
                background: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                  child: Container(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: smallSizedBoxHeight,
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.import_export,
                    size: 30,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  onPressed: () {
                    setState(() {
                      sortByNewest = !sortByNewest;
                    });
                  },
                ),
                Expanded(
                  child: CustomSearchTextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: smallerPadding,
            sliver: BlocProvider(
              create: (context) => vacationCubit,
              child: PlanTripListWidget(
                token: widget.token,
                vacationCubit: vacationCubit,
                sortByNewest: sortByNewest,
                searchQuery: searchQuery,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
