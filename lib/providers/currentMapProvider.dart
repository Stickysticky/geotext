import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/models/geoMapPoint.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currentMapProvider.g.dart';

@riverpod
class CurrentMapNotifier extends _$CurrentMapNotifier {

  @override
  GeoMap? build () {
    return null;
  }

  Future<void> setGeoMap (GeoMap? map) async {
    state = map;
    if(map is GeoMap){
      map.geoMapPoints = await GeoMapPoint.getGeoMapPointsByGeoMap(map);
    }
  }

  void updateCenterMap (LatLng center) {
    if(state is GeoMap){
      state!.initialCenter = center;
    }
  }
}