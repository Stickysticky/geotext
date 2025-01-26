import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geotext/models/geoMap.dart';
import 'package:geotext/providers/connectedUserProvider.dart';
import 'package:geotext/providers/currentMapProvider.dart';
import 'package:geotext/services/utils.dart';

import '../../generated/l10n.dart';
import 'myMaps.dart';

class MapCard extends ConsumerWidget {

  final GeoMap map;
  final bool isOwned;

  MapCard({required this.map, required this.isOwned});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return InkWell(
      onTap: () {
        ref.watch(currentMapNotifierProvider.notifier).setGeoMap(map);
        Navigator.pushNamed(context, '/map_view');
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 26.0, 16.0, 0),
        child:  Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Text(
                  map.title,
                  style: TextStyle(fontSize: 18.0),
                ),
                Spacer(),
                /*Icon(
                isOwned ? Icons.workspace_premium : Icons.group,
                color: Colors.brown.shade200,
                size: 40,
              ),*/
                if (isOwned)
                  IconButton(
                      onPressed: () =>
                     {
                       showDialog(
                           context: context,
                           builder: (BuildContext context) {
                             return AlertDialog(
                               title: Text(capitalizeFirstLetter(S.of(context).deleteMap)),
                               content: Text(capitalizeFirstLetter(S.of(context).deleteMapConfirmation(map.title))),
                               actions: [
                                 TextButton(
                                   child: Text(capitalizeFirstLetter(S.of(context).cancel)),
                                   onPressed: () {
                                     Navigator.of(context).pop();
                                   },
                                 ),
                                 TextButton(
                                   child: Text(
                                    capitalizeFirstLetter(S.of(context).delete),
                                     style: TextStyle(color: Colors.red),
                                   ),
                                   onPressed: () {
                                     map.deleteGeoMapAndPoints();
                                     ref.watch(connectedUserNotifierProvider)!.geoMapsOwner.remove(map);
                                     Navigator.pushReplacement(
                                       context,
                                       MaterialPageRoute(builder: (context) => MyMaps()),
                                     );
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(content: Text(capitalizeFirstLetter(S.of(context).deletedMap))),
                                     );
                                   },
                                 ),
                               ],
                             );
                           }
                       )
                     },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.brown.shade200,
                        size: 40,
                      ),
                  )


              ],
            )
        ),

      ),
    );
  }
}
