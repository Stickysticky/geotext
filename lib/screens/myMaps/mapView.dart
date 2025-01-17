import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geotext/commonWidgets/customAppBar.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/providers/currentMapProvider.dart';

class MapView extends ConsumerStatefulWidget {
  const MapView({super.key});

  @override
  ConsumerState<MapView> createState() => _MapViewState();
}

class _MapViewState extends ConsumerState<MapView> {
  List<Marker> markers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  Future<void> _loadMarkers() async {
    final GeoMap geoMap = ref.read(currentMapNotifierProvider)!;

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      markers = geoMap.geoMapPoints
          .map(
            (point) => Marker(
          point: LatLng(point.geoPoint.latitude, point.geoPoint.longitude),
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 40,
          ),
        ),
      )
          .toList();

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GeoMap geoMap = ref.read(currentMapNotifierProvider)!;

    return Scaffold(
      appBar: CustomAppBar(geoMap.title),
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(), // Afficher le loader
      )
          : FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(
            geoMap.initialCenter.latitude,
            geoMap.initialCenter.longitude,
          ),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }
}
