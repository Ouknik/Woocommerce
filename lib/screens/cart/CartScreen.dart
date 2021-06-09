import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:woocomerce/config.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/screens/ProductScreen/ProductScreen.dart';
import 'package:woocomerce/screens/cart/model/CartItem.dart';
import 'package:woocomerce/screens/checkout/checkoutScreen.dart';
import 'package:woocomerce/utili/Style.dart';

class CartScreen extends StatefulWidget {
  static final id = "CartScreen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   fotter =
    //
    //   // Add Your Code here.
    //
    // });

    return SafeArea(
      child: Scaffold(
          backgroundColor: BacgroundColors,
          persistentFooterButtons: [
            // buildFooter(cardWidth)
            buildFooter(cardWidth),
          ],

          // bottomSheet: buildSolidBottomSheet(context),
          appBar: AppBar(
            title: Text("Shopping Cart"),
          ),
          key: _scaffoldKey,
          // body: buildContainer(context, cardWidth),
          body: buildContainer(context, cardWidth)),
    );
  }

  Widget buildFooter(double cardWidth) {
    var mCartPriceWidget = Expanded(
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: 100, maxHeight: 50),
                decoration: BoxDecoration(
                  color: ButtonColors,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: CaderColors, offset: Offset(0, 1), blurRadius: 1)
                  ],
                ),
                child: Container(
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        style: sprice,
                        text:
                            "${context.read(cartChangeNotifierProvider).getTotalprice().toStringAsFixed(2)}",
                        children: [
                          TextSpan(text: 'dh', style: sproductNamBlack),
                          TextSpan(
                            // todo calculate total
                            text: "",
                            style: sprice,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CheckOutPage(),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Container(
                  constraints: BoxConstraints(maxWidth: 100, maxHeight: 50),
                  decoration: BoxDecoration(
                    color: ButtonColors,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: CaderColors,
                        offset: Offset(0, 5),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "paying",
                      style: sproductNamBlack,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
        height: 60,
        width: cardWidth,
        color: BacgroundColors,
        child: Container(
          width: cardWidth,
          child: Column(
            children: [
              mCartPriceWidget,
            ],
          ),
        ));
  }

  Widget buildContainer(BuildContext context, double cardWidth) {
    double height = MediaQuery.of(context).size.height;

    return Consumer(
      builder: (BuildContext context, ScopedReader watch, Widget child) {
        final cartList = watch(cartChangeNotifierProvider).cartList;

        return RefreshIndicator(
          onRefresh: () async {
            // return context.refresh(cartProvider);
            return print(cartList.length);
          },
          child: Container(
            color: BacgroundColors,
            width: cardWidth,
            child: cartList.length == 0
                ? Center(
                    child: Text(
                      "Shopping cart is empty",
                      style: stitleNameBlack,
                    ),
                  )
                : Container(
                    //  height: height - 200,
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                        thickness: 10,
                        color: BacgroundColors,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 0.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: cartList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var cartObject = cartList[index];

                        return buildGestureDetector(
                            context, cartObject, cardWidth, cartList);
                      },

                      // },
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget buildGestureDetector(BuildContext context, CartItem cartObject,
      double cardWidth, List<CartItem> cartList) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductsScreen(product: cartObject.product),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: CardColors,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: ContanairColors, offset: Offset(0, 05), blurRadius: 15)
            ],
          ),
          width: cardWidth,
          height: 150,
          child: Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// RightSid
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 100,
                  child: cartObject.product.images.length == 0
                      ? Image.network(ImageVide)
                      : Image.network("${cartObject.product.images[0].src}"),
                ),
              ),

              /// Center
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        cartObject.product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: sproductNamBlack,
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                cartObject.quantity++;
                              });
                            },
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (cartObject.quantity > 1) {
                                  cartObject.quantity--;
                                }
                              });
                            },
                            child: Icon(
                              Icons.remove_circle_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: RichText(
                                maxLines: 2,
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: '${cartObject.product.price}',
                                    style: sprice,
                                  ),
                                  TextSpan(text: 'dh', style: sproductNamBlack),
                                ])),
                          ),
                          Center(
                            child: Text(
                              '   x ${cartObject.quantity}',
                              style: sproductNamBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 5,
              ),

              /// left side
              Container(
                color: CaderColors,
                width: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 65),
                      child: Container(
                        // height: height,
                        child: GestureDetector(
                          onTap: () {
                            print(cartList.length);
                            setState(() {
                              cartList.remove(cartObject);
                            });
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
