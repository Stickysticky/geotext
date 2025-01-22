import 'package:geotext/models/customUser.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/geoMap.dart';

part 'connectedUserProvider.g.dart';

@riverpod
class ConnectedUserNotifier extends _$ConnectedUserNotifier {

  @override
  CustomUser? build () {
    return null;
  }

  void setUser(CustomUser? user) {
    state = user;
  }

  void updateEmail (String email) async {
    if(state is CustomUser){
      state?.email = email;
    }
  }

  void updateUserName (String userName) async {
    if(state is CustomUser){
      state?.userName = userName;
    }
  }

  void updateDisplayName (String displayName) async {
    if(state is CustomUser){
      state?.displayName = displayName;
    }
  }

  void addOwnedMap (GeoMap geoMap) async {
    if(state is CustomUser){
      state?.geoMapsOwner.add(geoMap);
    }
  }

  void updateMaps () async {
    if(state is CustomUser){
      state!.geoMapsOwner = await GeoMap.getMyMaps(state!);
      state!.geoMapsShared = await GeoMap.getSharedMaps(state!);
    }
  }
}