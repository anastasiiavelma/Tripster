import 'package:flutter/material.dart';
import 'package:tripster/utils/constants.dart';

class CustomSliverAppBarWidget extends StatefulWidget {
  final String title;

  const CustomSliverAppBarWidget({
    super.key,
    required this.title,
  });

  @override
  CustomSliverAppBarWidgetState createState() =>
      CustomSliverAppBarWidgetState();
}

class CustomSliverAppBarWidgetState extends State<CustomSliverAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.1,
      floating: true,
      pinned: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      surfaceTintColor: Theme.of(context).colorScheme.onBackground,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(
              left: 0,
              top: constraints.maxHeight - 70,
            ),
            title: Padding(
              padding: smallPadding,
              child: Row(
                children: [
                  IconButton(
                    color: Theme.of(context).colorScheme.shadow,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 15,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.shadow),
                  ),
                ],
              ),
            ),
            background: ColoredBox(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          );
        },
      ),
    );
  }
}
