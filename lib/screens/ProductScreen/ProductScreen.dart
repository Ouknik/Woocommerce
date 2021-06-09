import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:woocomerce/config.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/utili/Style.dart';
import 'package:woocomerce/screens/ProductScreen/productWidgets/ExpansionInfo.dart';
import 'package:woocommerce/models/products.dart';
import 'package:intl/intl.dart';

class ProductsScreen extends StatefulWidget {
  final WooProduct product;

  const ProductsScreen({Key key, this.product}) : super(key: key);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int quantity = 1;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, ScopedReader watch, Widget child) {
      // var screenSize = MediaQuery.of(context).size;
      int selectedImage = 0;
      var productsProvider = watch(productsChangeNotifierProvider);

      /// fav
      final favList = watch(favoriteChangeNotifierProvider);
      final isfav = favList.favoriteList.firstWhere(
          (element) => element.id == widget.product.id,
          orElse: () => null);

      // ///  Change selectedImage
      selectedImage = productsProvider.selectedImage ?? 0;

      //  Read quantity
      var hasImages = widget.product.images.length != 0;

      return SafeArea(
        child: Scaffold(
            appBar: new AppBar(
              backgroundColor: Colors.blue,
              title: new Text("MyAPP"),
            ),
            key: _scaffoldKey,
            backgroundColor: Colors.grey,
            body: ListView(
              children: [
                Column(
                  children: [
                    buildImage(selectedImage),
                  ],
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.only(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: (20)),
                        child: Center(
                          child: Text(
                            widget.product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: stitleNameBlack,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 160,
                          height: 2,
                          color: Colors.amber,
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 160,
                          height: 1,
                          color: Colors.red,
                        ),
                      ),
                      buildExpansionInfo(),
                      buildExpansionReviews(),
                      Container(
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
                              TextSpan(
                                  text:
                                      "${widget.product.ratingCount < 0 ? "4.0" : "4.0"}",
                                  style: ssizeinfo),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 1, right: 1),
                  child: Container(
                    width: double.infinity,
                    color: Colors.white60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            // overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            text: TextSpan(children: [
                              TextSpan(
                                text: '${widget.product.price}',
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 40,
                                ),
                              ),
                              TextSpan(text: 'dh', style: sproductNamBlack),
                            ])),
                        Icon(widget.product.stockStatus == "instock"
                            ? Icons.sentiment_satisfied_alt
                            : Icons.sentiment_dissatisfied),
                      ],
                    ),
                  ),
                ),
                buildAddToCartBtn(context),
              ],
            )),
      );
    });
  }

  Widget buildImage(int selectedImage) {
    return Container(
      child: SizedBox(
        width: double.infinity,
        child: AspectRatio(
          aspectRatio: 1,
          child: Hero(
            tag: Uuid(),
            child: widget.product.images.length != 0
                ? Image.network(widget.product.images[selectedImage].src)
                : Image.network(ImageVide),
          ),
        ),
      ),
    );
  }

  Widget buildNotLoggedView() {
    return Center(child: Text("PLease Log in to see Info"));
  }

  ExpansionInfo buildExpansionReviews() {
    return ExpansionInfo(
      text: Text('Notation', style: ssubleTitreNameBlack),
      expand: false,
      children: [
        Padding(
            padding: EdgeInsets.only(
              left: (20),
              right: (20),
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                widget.product.description.length <= 0
                    ? "is vide "
                    : Bidi.stripHtmlIfNeeded(widget.product.description),
                style: sproductNamBlack,
                maxLines: 3,
              ),
            )),
      ],
    );
  }

  ExpansionInfo buildExpansionInfo() {
    return ExpansionInfo(
      expand: false,
      text: Text(
        'Description : ',
        style: ssubleTitreNameBlack,
      ),
      children: [
        Padding(
            padding: EdgeInsets.only(
              left: (20),
              right: (20),
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                widget.product.description.length <= 0
                    ? "is vide "
                    : Bidi.stripHtmlIfNeeded(widget.product.description),
                style: sproductNamBlack,
                maxLines: 3,
              ),
            )),
      ],
    );
  }

  Container buildAddToCartBtn(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: (20)),
      padding: EdgeInsets.all(40),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white60,
        borderRadius: BorderRadius.only(),
      ),
      child: SizedBox(
        width: double.infinity,
        height: (56),
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.blue[300],
          onPressed: () async {
            var add = context
                .read(cartChangeNotifierProvider)
                .addToCart(wooProduct: widget.product, pQuantity: quantity);
            //var isExist = context.read(cartChangeNotifierProvider).isExist;
            Fluttertoast.showToast(
                msg: "product add to cart is secss..",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.black,
                fontSize: 16.0);
          },
          child: Text(
            "add to carte",
            style: sproductNamBlack,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
