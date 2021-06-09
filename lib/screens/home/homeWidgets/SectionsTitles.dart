import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocomerce/utili/Style.dart';

class SectionsTitles extends StatelessWidget {
  final String catId;

  const SectionsTitles(this.catId);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 2.7;
    double cardWidth = MediaQuery.of(context).size.width / 1.8;

    return Container(
      height: 100,
      child: Consumer(
        builder: (BuildContext context, ScopedReader watch, Widget child) {
          final categories = watch(productsProvider(catId));
          final s = categories.map(data: (asyncData) {
            var listOfcats = asyncData.value;
            // var catName = listOfcats[0].categories[1].name;

            // print("Bulit ${listOfcats.map((e) => e.images.length)}");

            var catName;
            for (var i = 0; i < listOfcats[0].categories.length; i++) {
              // print(" i == $i");
              if (i > 0 == true) {
                catName = listOfcats[0].categories[1].name;
              } else {
                catName = listOfcats[0].categories[0].name;
              }
            }

            final catTitle = Container(
              color: SectionTitleColors,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "${catName}",
                    style: ssubleTitreNameBlack,
                  ),
                ),
              ),
            );
            return catTitle;
          }, loading: (asyncData) {
            return spinkit;
          }, error: (error) {
            return Text(error.toString());
          });
          return s;
        },
      ),
    );
  }
}
