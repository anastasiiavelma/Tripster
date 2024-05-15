import 'package:geocoding/geocoding.dart';

class LocationToAddress {
  final double latitude;
  final double longitude;

  LocationToAddress({required this.latitude, required this.longitude});

  Future<Map<String, String>> getAddressDetails() async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return {
          'country': place.country ?? 'Unknown Country',
          'city': place.locality ?? 'Unknown City',
        };
      } else {
        return {
          'country': 'No results found',
          'city': 'No results found',
        };
      }
    } catch (e) {
      print('Error fetching address: $e');
      return {
        'country': 'Unable to fetch country',
        'city': 'Unable to fetch city',
      };
    }
  }
}
