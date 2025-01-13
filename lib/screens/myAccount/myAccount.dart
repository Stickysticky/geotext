import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geotext/commonWidgets/customAppBar.dart';
import 'package:geotext/providers/connectedUserProvider.dart';
import 'package:geotext/screens/myAccount/accountCard.dart';
import '../../generated/l10n.dart';
import '../../models/customUser.dart';
import '../../services/utils.dart';

class MyAccount extends ConsumerWidget {
  MyAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomUser user = ref.watch(connectedUserNotifierProvider) as CustomUser;

    return Scaffold(
      backgroundColor: Colors.brown.shade50,
      appBar: CustomAppBar(S.of(context).myAccount),
      body: Card(
        margin: EdgeInsets.fromLTRB(6.0, 16.0, 6.0, 0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            AccountCard(
                capitalizeFirstLetter(S.of(context).userName),
                user.userName ?? '',
                true,
                user,
                ref,
                updateUserNameAndSave
            ),
            Divider(
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            AccountCard(
                capitalizeFirstLetter(S.of(context).userDisplayName),
                user.userDisplayName ?? '',
                true,
                user,
                ref,
                updateDisplayNameAndSave
            ),
            Divider(
              thickness: 1,
              indent: 16,
              endIndent: 16,
            ),
            AccountCard(
                capitalizeFirstLetter(S.of(context).email),
                user.email ?? '',
                true,
                user,
                ref,
                updateEmailAndSave
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateEmailAndSave (WidgetRef ref, CustomUser user, String email) async {
    ref.read(connectedUserNotifierProvider.notifier).updateEmail(email);
    user.email = email;
    user.save();
  }

  Future<void> updateUserNameAndSave (WidgetRef ref,CustomUser user, String userName) async {
    ref.read(connectedUserNotifierProvider.notifier).updateUserName(userName);
    user.userName = userName;
    user.save();
  }

  Future<void> updateDisplayNameAndSave (WidgetRef ref,CustomUser user, String displayName) async {
    ref.read(connectedUserNotifierProvider.notifier).updateDisplayName(displayName);
    user.userDisplayName = displayName;
    user.save();
  }
}
