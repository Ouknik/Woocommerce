import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/screens/ProductScreen/ProductScreen.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocomerce/utili/Style.dart';

import '../../../config.dart';

class wProductRow extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    var catID = watch(productsChangeNotifierProvider).catId;
    final favList = watch(favoriteChangeNotifierProvider);
    final productsProviderData = watch(productsProvider(catID));
    var body = productsProviderData.map(data: (asyncData) {
      var products = asyncData.value;

      double height = MediaQuery.of(context).size.height / 2.7;
      double cardWidth = MediaQuery.of(context).size.width / 1.8;
      var body = ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(
          thickness: 1,
          color: Colors.black,
        ),
        padding: EdgeInsets.symmetric(horizontal: 0.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: products.length,

        itemBuilder: (BuildContext context, int index) {
          var product = products[index];
          final isfav = favList.favoriteList.firstWhere(
              (element) => element.id == products[index].id,
              orElse: () => null);
          final width = MediaQuery.of(context).size.width;
          var productImage = '';
          var productprice = products[index].price ?? "0.0";

          var hasImage = products[index].images.length > 0;
          if (hasImage) {
            productImage = products[index].images[0].src;
          } else {
            productImage = "$ImageVide";
          }

          return Container(
            color: Colors.grey,
            child: Column(
              children: [
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
                      width: width,
                      height: 150,
                      child: Stack(
                        children: [
                          Row(
                            textDirection: TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// image
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => spinkit,
                                      imageUrl: productImage ?? '',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                width: 1,
                                color: Colors.white,
                              ),

                              /// Center
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Directionality(
                                        textDirection: TextDirection.ltr,
                                        child: ListTile(
                                          title: Text(
                                            product.name,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 4,
                                            style: sproductNamBlack,
                                          ),
                                          subtitle: Text(product.type ?? ""),
                                          trailing: product.onSale
                                              ? Container(
                                                  height: 20,
                                                  width: 50,
                                                  color: Colors.yellow
                                                      .withOpacity(0.4),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            1.0),
                                                    child: Center(
                                                      child: Text(
                                                        "${product.onSale}",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : SizedBox.shrink(),
                                          isThreeLine: false,
                                        ),
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Center(
                                            child: RichText(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: '$productprice',
                                                    style: sprice,
                                                  ),
                                                  TextSpan(
                                                      text: ' dh',
                                                      style: sprice),
                                                ])),
                                          ),

                                          /// Rating
                                          Container(
                                            height: 40,
                                            child: Center(
                                              child: Text.rich(
                                                TextSpan(children: <InlineSpan>[
                                                  WidgetSpan(
                                                    child: Icon(
                                                      Icons.star,
                                                      size: 14,
                                                      color: Colors.yellow,
                                                    ),
                                                  ),
                                                  TextSpan(text: " "),
                                                  TextSpan(
                                                      text:
                                                          "${product.ratingCount < 0 ? "4.0" : "4.0"}",
                                                      style: sproductNamBlack),
                                                ]),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ],
                                ),
                              ),

                              /// left side
                              Container(
                                width: 1,
                                color: Colors.black12,
                              ),

                              Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      textDirection: TextDirection.ltr,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            isfav == null
                                                ? favList
                                                    .addToFav(products[index])
                                                : favList.removeFromFav(
                                                    products[index]);
                                          },
                                          child: isfav == null
                                              ? Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.red,
                                                )
                                              : Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            var add = context
                                                .read(
                                                    cartChangeNotifierProvider)
                                                .addToCart(
                                                    wooProduct: product,
                                                    pQuantity: 1);
                                            showBottomSheet(
                                                context: context,
                                                builder: (context) => Container(
                                                    child: Text(
                                                      "prodect add to shipping cart",
                                                      style: stitleNameWhaite,
                                                    ),
                                                    width: double.infinity,
                                                    height: 50,
                                                    color: Colors.green));
                                          },
                                          child: Icon(Icons.shopping_cart),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Row(
                                          textDirection: TextDirection.rtl,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                await launchShare(context, "s");
                                              },
                                              child: Icon(
                                                Icons.share,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },

        // },
      );

      return RefreshIndicator(
        onRefresh: () {
          return context.refresh(productsProvider(catID));
        },
        child: Container(padding: EdgeInsets.all(1), child: body),
      );
    }, loading: (asyncData) {
      return spinkit;
    }, error: (error) {
      return Text(error.toString());
    });

    return body;
  }
}
