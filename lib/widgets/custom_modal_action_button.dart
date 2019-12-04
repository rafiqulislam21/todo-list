import 'package:flutter/material.dart';

import 'custom_button.dart';

class CustomModalActionButton extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onSave;

  CustomModalActionButton({@required this.onClose, @required this.onSave});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomButton(
          onPressed: onClose,
//              () {Navigator.of(context).pop();},
          buttonText: "Close",
//                color: Colors.white,
//                textColor: Theme.of(context).accentColor,
//                borderColor: Theme.of(context).accentColor,
        ),
        CustomButton(
          onPressed: onSave,
          buttonText: "Save",
          color: Colors.white,
          textColor: Theme.of(context).accentColor,
          borderColor: Theme.of(context).accentColor,
        ),
      ],
    );
  }
}
