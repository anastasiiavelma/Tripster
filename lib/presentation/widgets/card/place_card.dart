import 'package:flutter/material.dart';
import 'package:tripster/domain/models/place_model.dart';
import 'package:tripster/presentation/widgets/adress_widget.dart';
import 'package:tripster/utils/constants.dart';

class PlaceCardWidget extends StatelessWidget {
  final Place place;
  const PlaceCardWidget({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: smallerPadding,
      child: Container(
        width: double.infinity,
        child: Card(
          color: Theme.of(context).colorScheme.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              alignment: Alignment.topCenter,
              width: 100,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      place.imageUrl,
                      height: 160.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  smallSizedBoxHeight,
                  Text(
                    place.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  smallSizedBoxHeight,
                  Text(
                    place.description,
                    maxLines: 2,
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge
                        ?.copyWith(fontWeight: FontWeight.w400, fontSize: 17),
                    overflow: TextOverflow.ellipsis,
                  ),
                  smallSizedBoxHeight,
                  smallSizedBoxHeight,
                  AddressWidget(
                      latitude: place.latitude, longitude: place.longitude),
                  smallSizedBoxHeight,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
