import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';
import 'package:woocomerce/screens/cart/CartScreen.dart';
import 'package:woocomerce/widgets/WebView.dart';
import 'package:woocomerce/utili/Style.dart';
import '../config.dart';

/// helpers =====================================================================================================

final spinkit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration:
          BoxDecoration(color: index.isEven ? Colors.grey : Colors.black),
    );
  },
);

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

pushNewScreen(context, dist) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (BuildContext context) => dist,
    ),
  );
}

Future launchForgetPassworddWebView(context, String url) async {
  await Navigator.push(
    context,
    MaterialPageRoute<void>(
      builder: (BuildContext context) =>
          WebView(url: url, title: "My new password"),
      fullscreenDialog: true,
    ),
  );
}

Future launchShare(context, String url) async {
  await Share.share('is share that apk in my store $MyStor');
}

mShowSnackBar(context, content, actionLabel) {
  final snackBar = SnackBar(
    content: Text(
      "$content",
      style: ssizeinfo,
    ),
    backgroundColor: Colors.white,
    action: SnackBarAction(
      label: '$actionLabel',
      onPressed: () async {
        // _scaffoldKey.currentState.hideCurrentSnackBar();
        if (actionLabel == "yes") {
          print("AA");
          // await  CustomDialog1.editQuantity(context, "title", "body");
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CartScreen(),
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CartScreen(),
            ),
          );
        }
        // Some code to undo the change.
      },
    ),
  );
  return snackBar;
}
