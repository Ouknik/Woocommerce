import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocomerce/utili/Style.dart';

class wCategories extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var categoriesProvider = watch(productsCategoriesProvider);

    final body = categoriesProvider.when(data: (asyncData) {
      var categories = asyncData;

      var changeColor = watch(productsChangeNotifierProvider).selectedIndex;

      var content = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length == null ? 10 : categories.length,
            itemBuilder: (context, index) {
              var currentCat = categories[index];
              var selectedIndex;

              return Container(
                color: SectionTitleColors,
                child: GestureDetector(
                  onTap: () {
                    var changedCatID = context
                        .read(productsChangeNotifierProvider)
                        .catId = "${currentCat.id.toString()}";
                    print("CATID : ${changedCatID}");
                    selectedIndex = context
                        .read(productsChangeNotifierProvider)
                        .changeSelectedIndex(index);

                    print(selectedIndex);
                  },
                  child: Card(
                    elevation: 0,
                    color:
                        changeColor == index ? Colors.grey : Colors.grey[200],
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                      color: changeColor == index ? Colors.black : Colors.white,
                      width: 2.0,
                    )),
                    child: Stack(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    currentCat.name,
                                    textDirection: TextDirection.ltr,
                                    maxLines: 1,
                                    style: ssubleTitreNameBlack,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          margin: const EdgeInsets.all(10),
                          width: 120,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
      return content;
    }, loading: () {
      return spinkit;
    }, error: (error, ee) {
      return Text(error.toString());
    });

    return body;
  }
}
