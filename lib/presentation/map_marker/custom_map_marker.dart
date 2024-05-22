import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late GoogleMapController _controller;
  Set<Marker> _markers = {};
  TextEditingController _searchController = TextEditingController();
  final ValueNotifier<CameraPosition> currentCameraPosition = ValueNotifier(
      const CameraPosition(target: LatLng(50.4501, 30.5234), zoom: 9));
  @override
  void initState() {
    super.initState();
    _loadMarkersFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onBackground,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Enter city name',
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.background,
                ),
          ),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.background,
              ),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) => _searchCity(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _searchCity,
          ),
        ],
      ),
      body: GoogleMap(
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          new Factory<OneSequenceGestureRecognizer>(
            () => new EagerGestureRecognizer(),
          ),
        ].toSet(),
        myLocationEnabled: true,
        rotateGesturesEnabled: true,
        scrollGesturesEnabled: true,
        tiltGesturesEnabled: false,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: currentCameraPosition.value,
        minMaxZoomPreference: const MinMaxZoomPreference(8, 19),
        markers: _markers,
        onTap: _onMapTapped,
        onCameraMove: _onCameraMove,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _markers.clear();
          _saveMarkersToPrefs();
          setState(() {});
        },
        tooltip: 'Clear Markers',
        child: Icon(Icons.clear),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _onMapTapped(LatLng location) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(location.toString()),
          position: location,
          infoWindow: InfoWindow(
            title: 'New Marker',
          ),
        ),
      );
      _saveMarkersToPrefs();
    });
  }

  void _onCameraMove(CameraPosition position) {
    print("On Camera Move method $position");
    // _controller
    //     .moveCamera(CameraUpdate.newLatLng(currentCameraPosition.value.target));
    currentCameraPosition.value = position;
  }

  Future<void> _searchCity() async {
    String city = _searchController.text;
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a city name'),
        ),
      );
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(city);
      if (locations.isNotEmpty) {
        _controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(locations[0].latitude, locations[0].longitude),
            14.0,
          ),
        );
        setState(() {
          _markers.add(
            Marker(
              markerId: MarkerId(city),
              position: LatLng(locations[0].latitude, locations[0].longitude),
              infoWindow: InfoWindow(
                title: city,
              ),
            ),
          );
        });
        _saveMarkersToPrefs();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('City not found'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  Future<void> _loadMarkersFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? markersJson = prefs.getString('markers');
    if (markersJson != null) {
      Iterable decoded = jsonDecode(markersJson);
      setState(() {
        _markers = decoded.map((marker) {
          return Marker(
            markerId: MarkerId(marker['id']),
            position: LatLng(marker['latitude'], marker['longitude']),
            infoWindow: InfoWindow(
              title: marker['title'],
            ),
          );
        }).toSet();
      });
    }
  }

  Future<void> _saveMarkersToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> markersList = _markers.map((marker) {
      return {
        'id': marker.markerId.value,
        'latitude': marker.position.latitude,
        'longitude': marker.position.longitude,
        'title': marker.infoWindow.title,
      };
    }).toList();
    prefs.setString('markers', jsonEncode(markersList));
  }
}
