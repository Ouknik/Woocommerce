import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:woocomerce/config.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/screens/store/StoreScreen.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocomerce/utili/Style.dart';

class CategoriesItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Consumer(
        builder: (BuildContext context, ScopedReader watch, Widget child) {
          final categories = watch(productsCategoriesProvider);

          var body = categories.map(data: (asyncData) {
            var listOfcats = asyncData.value;
            var content = GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => StoreScreen(),
                  ),
                );
              },
              child: Container(
                color: BacgroundColors,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 0.0),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: listOfcats.length,
                  itemBuilder: (BuildContext context, int index) {
                    var catName = listOfcats[index].name;
                    var catImage = listOfcats[index].image;
                    var count = asyncData.value.length;
                    return Container(
                      width: 150,
                      child: Card(
                        color: CaderColors,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100,
                                height: 50,
                                child: CircleAvatar(
                                  child: catImage == null
                                      ? CachedNetworkImage(imageUrl: ImageVide)
                                      : CachedNetworkImage(
                                          imageUrl: catImage.src),
                                ),
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: 0,
                              child: Container(
                                color: BacgrountItemCategoriest,
                                child: Center(
                                    child: Text("$catName ",
                                        style: sproductNamWhaite,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  // },
                ),
              ),
            );
            return content;
          }, loading: (asyncData) {
            return spinkit;
          }, error: (error) {
            return Text(error.toString());
          });
          return body;
        },
      ),
    );
  }
}
