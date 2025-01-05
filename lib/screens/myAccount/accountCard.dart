import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/customUser.dart';

class AccountCard extends StatefulWidget {
  bool _writeable;
  String _fieldName;
  dynamic _userValue;
  CustomUser _user;
  final Future<void> Function(CustomUser, String) _update;


  AccountCard(this._fieldName, this._userValue, this._writeable, this._user,
      this._update);

  @override
  State<AccountCard> createState() => _AccountcardState();
}

class _AccountcardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        showDialogModification(context, widget._fieldName, widget._userValue)
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget._fieldName,
              style: TextStyle(
                  fontSize: 17,
                fontWeight: FontWeight.bold
              ),
            ),
            Spacer(),
            Text(
              widget._userValue,
              textAlign: TextAlign.right,
            ),
            if (widget._writeable)
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  void showDialogModification(BuildContext context, String fieldName, String userValue) {
    TextEditingController userValueController = TextEditingController(
      text: userValue
    );

    showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(fieldName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userValueController
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(S.of(context).cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget._userValue = userValueController.text;
                  widget._update(widget._user, userValueController.text);
                });
                Navigator.of(dialogContext).pop();
              },
              child: Text(S.of(context).save),
            ),
          ],
        );
      }
    );

  }
}
