import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:woocomerce/utili/Constants.dart';

class ExpansionInfo extends StatelessWidget {
  final Text text;
  final bool expand;
  final List<Widget> children;

  ExpansionInfo(
      {@required this.text, @required this.children, this.expand = false});

  @override
  Widget build(BuildContext context) {
    return ConfigurableExpansionTile(
      initiallyExpanded: expand,
      headerExpanded: Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: <Widget>[
              const SizedBox(width: 15),
              const SizedBox(width: 15),
              text,
              const Spacer(),
              Icon(
                Icons.keyboard_arrow_up,
                color: Theme.of(context).accentColor,
                size: 20,
              ),
              const SizedBox(width: 15),
            ],
          ),
        ),
      ),
      header: Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Row(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              text,
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.black26,
                size: 20,
              ),
            ],
          ),
        ),
      ),
      children: children,
    );
  }
}
