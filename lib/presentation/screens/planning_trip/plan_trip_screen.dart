import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tripster/domain/models/vacation_model.dart';
import 'package:tripster/presentation/screens/planning_trip/detail_plan_screen.dart';
import 'package:tripster/presentation/widgets/buttons/change_theme_button.dart';
import 'package:tripster/utils/constants.dart';

class PlanTripScreen extends StatelessWidget {
  final String? token;
  const PlanTripScreen({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                // !!! to-do: delete
                ThemeButton(),
                Text(
                  'My trips',
                  style: TextStyle(fontSize: 30.0),
                ),
              ],
            ),
            backgroundColor: Colors.transparent,
            expandedHeight: 110.0,
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              child: Container(
                height: 110,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
          SliverPadding(
            padding: smallerPadding,
            sliver: PlanTripListWidget(),
          ),
        ],
      ),
    );
  }
}

class PlanTripListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final vacation = vacations[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPlanTripScreen(
                      vacation: vacation,
                    ),
                  ));
            },
            child: FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: CardWidget(vacation: vacation)),
          );
        },
        childCount: vacations.length,
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final Vacation vacation;
  const CardWidget({
    super.key,
    required this.vacation,
  });

  @override
  Widget build(BuildContext context) {
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
            width: 130,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                      'https://images.unsplash.com/photo-1569622296640-38737c1d82de?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover),
                ),
                smallSizedBoxHeight,
                Text(
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    vacation.name,
                    style: Theme.of(context).textTheme.headlineLarge
                    // ?.copyWith(color: kBackgroundColor),
                    ),
                smallSizedBoxHeight,
                Row(
                  children: [
                    Icon(Icons.location_on, color: kBackgroundColor),
                    smallerSizedBoxWidth,
                    Text(
                      vacation.location,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
                smallSizedBoxHeight,
                Row(
                  children: [
                    Icon(Icons.date_range_outlined, color: kBackgroundColor),
                    smallerSizedBoxWidth,
                    Text(
                      vacation.dateStart.toString().substring(0, 10),
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontWeight: FontWeight.normal),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.money_outlined, color: Color(0xFF6e191d)),
                    smallerSizedBoxWidth,
                    Text(
                      '${vacation.fullBudget.toString()} Dollars',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(color: Color(0xFF6e191d)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
