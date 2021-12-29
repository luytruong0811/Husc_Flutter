import 'package:flutter/cupertino.dart';

Widget succesfulMessageDialog(BuildContext context, {String content = ''}) {
  return CupertinoAlertDialog(
    title: Text('Thành công'),
    content: Text('$content thành công'),
    actions: <Widget>[
      CupertinoDialogAction(
        isDefaultAction: true,
        child: Text("Chấp nhận"),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}

Widget confirmDialog(BuildContext context, String title, String content) {
  return CupertinoAlertDialog(
    title: Text(title),
    content: Text(content),
    actions: <Widget>[
      CupertinoDialogAction(
        isDefaultAction: true,
        child: Text(title),
        onPressed: () => Navigator.pop(context, true),
      ),
      CupertinoDialogAction(
        isDefaultAction: false,
        child: Text("Huỷ"),
        onPressed: () => Navigator.pop(context, false),
      ),
    ],
  );
}
