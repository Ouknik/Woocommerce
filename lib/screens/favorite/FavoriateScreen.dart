import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:woocomerce/config.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/screens/ProductScreen/ProductScreen.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocomerce/utili/Style.dart';

class FavoraiteScreen extends ConsumerWidget {
  static final id = "FavoraiteScreen";

  int quantity = 1;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    double height = MediaQuery.of(context).size.height / 2.7;
    double cardWidth = MediaQuery.of(context).size.width / 1.8;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    final favList = watch(favoriteChangeNotifierProvider);

    var body = ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(
        thickness: 1,
        color: Colors.black,
      ),
      padding: EdgeInsets.symmetric(horizontal: 0.0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: favList.favoriteList.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var product = favList.favoriteList[index];

        final width = MediaQuery.of(context).size.width;

        var productprice = product.price ?? "0.0";
        var productImage = ImageVide;
        var hasImage = product.images.length > 0;
        if (hasImage) {
          productImage = product.images[0].src;
        } else {
          productImage = ImageVide;
        }

        return Column(children: [
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductsScreen(product: product),
                  ),
                );
              },
              child: Card(
                  margin: EdgeInsets.all(10),
                  child: Container(
                      color: ContanairColors,
                      height: 150,
                      child: Stack(
                        children: [
                          ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: productImage ?? '',
                              height: 150,
                              width: 120,
                              fit: BoxFit.fill,
                            ),
                            title: Text(
                              product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              style: sproductNamBlack,
                            ),
                            subtitle: Text(
                              '$productprice dh',
                              style: sprice,
                            ),
                            trailing: GestureDetector(
                              onTap: () async {
                                favList
                                    .removeFromFav(favList.favoriteList[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))))
        ]);
      },
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Favorite"),
        actions: [
          Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          Icon(
            Icons.favorite,
            color: Colors.red,
          )
        ],
      ),
      backgroundColor: BacgroundColors,
      body: SingleChildScrollView(
        child: Column(
          children: [
            body,
          ],
        ),
      ),
    );
  }
}
