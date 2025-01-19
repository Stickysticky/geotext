

import 'package:geotext/models/geoMapPoint.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currentGeoMapPointProvider.g.dart';

@riverpod
class CurrentGeoMapPointNotifier extends _$CurrentGeoMapPointNotifier{

  @override
  GeoMapPoint? build () {
    return null;
  }

  void setGeoMapPoint (GeoMapPoint? point) {
    state = point;
  }
}