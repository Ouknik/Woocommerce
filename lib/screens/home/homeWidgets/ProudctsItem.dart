import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:uuid/uuid.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/screens/ProductScreen/ProductScreen.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocommerce/models/products.dart';
import 'package:woocomerce/utili/Style.dart';
import '../../../config.dart';

class ProductItem extends StatelessWidget {
  final String catId;
  const ProductItem(this.catId);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 2.7;
    double cardWidth = MediaQuery.of(context).size.width / 1.8;

    return Container(
      height: 300,
      child: Consumer(
        builder: (BuildContext context, ScopedReader watch, Widget child) {
          final productsList = watch(productsProvider(catId));
          final favList = watch(favoriteChangeNotifierProvider);
          final body = productsList.map(data: (asyncData) {
            var _listProducts = asyncData.value;
            var content = Container(
              color: CaderColors,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                // physics: ClampingScrollPhysics(),
                // physics: RangeMaintainingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: _listProducts.length,
                itemBuilder: (BuildContext context, int index) {
                  final product = _listProducts[index];
                  var productImage = '';

                  var hasImage = _listProducts[index].images.length > 0;
                  if (hasImage) {
                    productImage = _listProducts[index].images[0].src;
                  } else {
                    productImage =
                        'https://complianz.io/wp-content/uploads/2019/03/placeholder-300x202.jpg';
                  }
                  var productName = _listProducts[index].name;
                  var productprice = _listProducts[index].price;
                  var productprice2 = _listProducts[index].stockStatus;
                  var productRatingCount = _listProducts[index].ratingCount;
                  var productRating = _listProducts[index].averageRating;
                  final isfav = favList.favoriteList.firstWhere(
                      (element) => element.id == _listProducts[index].id,
                      orElse: () => null);
                  return buildInkWell(
                      context,
                      product,
                      height,
                      cardWidth,
                      isfav,
                      favList,
                      _listProducts,
                      index,
                      productRatingCount,
                      productRating,
                      productImage,
                      productName,
                      productprice,
                      productprice2);
                },

                // },
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

  Widget buildInkWell(
      BuildContext context,
      WooProduct product,
      double height,
      double cardWidth,
      WooProduct isfav,
      FavoriteNotifier favList,
      List<WooProduct> products,
      int i,
      int productRatingCount,
      String productRating,
      String productImage,
      String productName,
      String productprice,
      String productprice2) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductsScreen(
              product: product,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(14),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
            bottomLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          height: height,
          width: cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //hna dyal add to carte mn homeScren
                  GestureDetector(
                    onTap: () async {
                      var add = context
                          .read(cartChangeNotifierProvider)
                          .addToCart(wooProduct: product, pQuantity: 1);
                      Fluttertoast.showToast(
                          msg: "Product add to cart Secss..",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.black,
                          fontSize: 16.0);
                    },
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.shopping_cart_rounded,
                          color: Colors.black,
                        )),
                  ),
                  //favorite**********
                  GestureDetector(
                    onTap: () {
                      isfav == null
                          ? favList.addToFav(products[i])
                          : favList.removeFromFav(products[i]);
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
              Expanded(
                child: Container(
                  child: Hero(
                    tag: Uuid(),
                    child: CachedNetworkImage(
                      imageUrl: productImage ?? '',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              AutoSizeText.rich(
                //name se produite *************
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${productName}',
                      style: sproductNamBlack,
                    ),
                  ],
                ),
                minFontSize: MINFONTSIZE,
                maxFontSize: 16,
                textDirection: TextDirection.ltr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //lflous **********************
                  AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${productprice.toString()} dh',
                          style: sprice,
                        ),
                      ],
                    ),
                    minFontSize: MINFONTSIZE,
                    maxFontSize: 22,
                    textDirection: TextDirection.ltr,
                    softWrap: true,
                    maxLines: 1,
                  ),

                  AutoSizeText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${product.stockStatus}',
                          style: sproductNamBlack,
                        ),
                      ],
                    ),
                    minFontSize: MINFONTSIZE,
                    maxFontSize: 22,
                  ),
                ],
              ),
              Row(
                textDirection: TextDirection.ltr,
                children: [
                  //Spacer(),
                  SmoothStarRating(
                      allowHalfRating: false,
                      onRated: (v) {},
                      starCount: 1,
                      rating: productRatingCount.toDouble(),
                      size: 16.0,
                      isReadOnly: true,
                      color: Colors.lime[900],
                      borderColor: Colors.amber[400],
                      spacing: 0.0),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    child: Text(
                      productRatingCount <= 0
                          ? "3.0"
                          : productRating.toString(),
                      style: sproductNamBlack,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
