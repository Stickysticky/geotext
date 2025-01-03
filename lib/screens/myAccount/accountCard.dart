import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/customUser.dart';

class AccountCard extends StatefulWidget {
  bool _writeable = false;
  String _fieldName;
  dynamic _userValue;

  AccountCard(this._fieldName, this._userValue, this._writeable);

  @override
  State<AccountCard> createState() => _AccountcardState();
}

class _AccountcardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget._fieldName,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            widget._userValue,
          ),
          if (widget._writeable)
            Icon(
              Icons.chevron_right,
              size: 20,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}
