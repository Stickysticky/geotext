import 'package:geotext/models/geoMap.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'currentMapProvider.g.dart';

@riverpod
class CurrentMapNotifier extends _$CurrentMapNotifier {

  @override
  GeoMap? build () {
    return null;
  }

  void setGeoMap (GeoMap? map){
    state = map;
  }
}