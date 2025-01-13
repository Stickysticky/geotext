

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotext/commonWidgets/customAppBar.dart';

import '../../generated/l10n.dart';

class MyMaps extends ConsumerWidget {
  const MyMaps({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: CustomAppBar(S.of(context).myMaps),
    );
  }
}
