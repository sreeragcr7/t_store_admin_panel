import 'package:flutter/material.dart';

class TDialogs {
  static defaultDialog({
    required BuildContext context,
    String title = 'Removel Confirmation',
    String content = 'Removing this data will delete all related data. Are you sure?',
    String cancelText = 'Cancle',
    String confirmText = 'Remove',
    Function()? onCancle,
    Function()? onConfirm,
  }) {
    //Show a confirmation Dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(onPressed: onCancle ?? () => Navigator.of(context).pop(), child: Text(cancelText)),
            TextButton(onPressed: onConfirm, child: Text(confirmText)),
          ],
        );
      },
    );
  }
}
