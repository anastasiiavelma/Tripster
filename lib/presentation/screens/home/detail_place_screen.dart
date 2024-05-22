import 'package:flutter/material.dart';
import 'package:tripster/domain/models/place_model.dart';
import 'package:tripster/presentation/screens/home/maps.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/presentation/widgets/adress_widget.dart';

class DetailPlaceScreen extends StatelessWidget {
  final Place place;
  const DetailPlaceScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            expandedHeight: 500.0,
            flexibleSpace: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40.0),
                bottomRight: Radius.circular(40.0),
              ),
              child: Image.network(
                height: 550,
                place.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: smallPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    place.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 24.0),
                  ),
                  smallSizedBoxHeight,
                  AddressWidget(
                      latitude: place.latitude, longitude: place.longitude),
                  smallSizedBoxHeight,
                  SizedBox(
                    height: 15,
                  ),
                  Text('Overview',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 15)),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    place.description,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  smallSizedBoxHeight,
                  smallSizedBoxHeight,
                  Center(
                    child: Maps(
                      latitude: place.latitude,
                      longitude: place.longitude,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
