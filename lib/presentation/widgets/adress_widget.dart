import 'package:flutter/material.dart';
import 'package:tripster/utils/constants.dart';
import 'package:tripster/utils/location_to_adress.dart';

class AddressWidget extends StatelessWidget {
  final double latitude;
  final double longitude;

  AddressWidget({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: LocationToAddress(latitude: latitude, longitude: longitude)
          .getAddressDetails(),
      builder: (context, AsyncSnapshot<Map<String, String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final country = snapshot.data!['country'];
          final city = snapshot.data!['city'];
          return Row(
            children: [
              Icon(Icons.location_on, color: kBackgroundColor),
              Text(
                '$country',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 18),
              ),
              if (city != null)
                Text(
                  ' $city',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontSize: 15, fontWeight: FontWeight.w400),
                ),
            ],
          );
        }
      },
    );
  }
}
