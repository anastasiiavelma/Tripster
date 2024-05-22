import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatelessWidget {
  final double latitude;
  final double longitude;

  const Maps({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 9.0,
    );

    return Container(
      width: 400,
      height: 200,
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: {
          Marker(
            markerId: MarkerId('Marker'),
            position: LatLng(latitude, longitude),
          ),
        },
      ),
    );
  }
}
