

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotext/providers/currentGeoMapPointProvider.dart';

import '../../models/geoMapPoint.dart';

class GeoMapPointCreator extends ConsumerStatefulWidget {
  const GeoMapPointCreator({super.key});

  @override
  ConsumerState<GeoMapPointCreator> createState() => _GeoMapPointCreatorState();
}

class _GeoMapPointCreatorState extends ConsumerState<GeoMapPointCreator> {
  @override
  Widget build(BuildContext context) {
    GeoMapPoint point = ref.read(currentGeoMapPointNotifierProvider)!;

    return const Placeholder();
  }
}
