// lib/screens/nearby_map_screen.dart
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NearbyMapScreen extends StatefulWidget {
  const NearbyMapScreen({super.key});

  @override
  State<NearbyMapScreen> createState() => _NearbyMapScreenState();
}

class _NearbyMapScreenState extends State<NearbyMapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(18.5204, 73.8567), // Pune
    zoom: 12.0,
  );

  final Set<Marker> _markers = {};
  final Completer<void> _markersLoadedCompleter = Completer<void>();
  
  BitmapDescriptor sanitationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor electricalIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor publicWorksIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor waterIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor trafficIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    _loadCustomMarkers();
    _fetchReportsAndAddMarkers();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    // --- FIX WAS HERE: Corrected typo 'asUint8List' ---
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void _loadCustomMarkers() async {
    final Uint8List sanitationBytes = await getBytesFromAsset('assets/images/pin-green.png', 100);
    final Uint8List electricalBytes = await getBytesFromAsset('assets/images/pin-blue.png', 100);
    final Uint8List publicWorksBytes = await getBytesFromAsset('assets/images/pin-red.png', 100);
    final Uint8List waterBytes = await getBytesFromAsset('assets/images/pin-cyan.png', 100);
    final Uint8List trafficBytes = await getBytesFromAsset('assets/images/pin-yellow.png', 100);

    // --- FIX WAS HERE: Corrected deprecated 'fromBytes' to 'bytes' ---
    sanitationIcon = BitmapDescriptor.bytes(sanitationBytes);
    electricalIcon = BitmapDescriptor.bytes(electricalBytes);
    publicWorksIcon = BitmapDescriptor.bytes(publicWorksBytes);
    waterIcon = BitmapDescriptor.bytes(waterBytes);
    trafficIcon = BitmapDescriptor.bytes(trafficBytes);

    _markersLoadedCompleter.complete();
  }

  BitmapDescriptor getMarkerIcon(String? department) {
    switch (department) {
      case 'Sanitation Dept.': return sanitationIcon;
      case 'Electrical Dept.': return electricalIcon;
      case 'Public Works Dept.': return publicWorksIcon;
      case 'Water Supply Dept.': return waterIcon;
      case 'Traffic Dept.': return trafficIcon;
      default: return BitmapDescriptor.defaultMarker;
    }
  }

  void _fetchReportsAndAddMarkers() async {
    await _markersLoadedCompleter.future;

    FirebaseFirestore.instance.collection('reports').snapshots().listen((snapshot) {
      if (mounted) {
        setState(() {
          _markers.clear();
          for (var doc in snapshot.docs) {
            var data = doc.data();
            GeoPoint point = data['location'];
            final marker = Marker(
              markerId: MarkerId(doc.id),
              position: LatLng(point.latitude, point.longitude),
              icon: getMarkerIcon(data['suggestedDept']),
              infoWindow: InfoWindow(
                title: data['category'],
                snippet: data['address'],
              ),
            );
            _markers.add(marker);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Issues'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        markers: _markers,
      ),
    );
  }
}