

import 'package:cloud_firestore/cloud_firestore.dart';
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

  void updatePointFromPoint (GeoMapPoint point){
    if(state is GeoMapPoint){
      state?.title = point.title;
      state?.message = point.message;
      state?.color = point.color;
      state?.radius = point.radius;
      state?.geoMap = point.geoMap;
    }
  }
}