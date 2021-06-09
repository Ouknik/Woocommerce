import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:woocomerce/config.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/screens/ButtonNavigatorBar.dart';
import 'package:woocomerce/screens/cart/model/CartItem.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocomerce/utili/Style.dart';
import 'package:woocommerce/models/order.dart';
import 'package:woocommerce/models/order_payload.dart';
import 'package:woocommerce/models/order_payload.dart' as LineItems;
import 'package:woocommerce/models/shipping_method.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  WooOrder orderCreated;
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width;

    return Consumer(builder: (context, ScopedReader watch, consumerChild) {
      /// Cart items
      CartNotifier cartProvider = watch(cartChangeNotifierProvider);

      /// Customer provider
      AsyncValue<WooCustomer> customerProvider = watch(usersProvider);

      var body = customerProvider.when(data: (asynData) {
        WooCustomer userData = asynData;
        print("data  : ${userData.shipping.address1}");
        var content = SafeArea(
          child: Scaffold(
            persistentFooterButtons: [
              // buildFooter(cardWidth)
              // buildFooter(context,cardWidth),
              buildFooter(cardWidth, context, userData, cartProvider.cartList),
            ],
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text("Paying"),
            ),
            body: Builder(builder: (context) {
              return SingleChildScrollView(
                child: Column(
                  textDirection: TextDirection.ltr,
                  children: [
                    selectedAddressSection(userData),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Shipping",
                          style: ssubleTitreNameBlack,
                        ),
                      ),
                    ),
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: shippingSection()),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Paying",
                          style: ssubleTitreNameBlack,
                        ),
                      ),
                    ),
                    Directionality(
                        textDirection: TextDirection.ltr,
                        child: paymentSection()),
                    priceSection(
                      context,
                    ),
                  ],
                ),
              );
            }),
          ),
        );

        return content;
      }, loading: () {
        return spinkit;
      }, error: (error, e) {
        return Text(error.toString());
      });
      return body;
    });
  }

  Widget shippingSection() {
    return Card(
      child: RadioListTile(
        value: 1,
        groupValue: 1,
        onChanged: (isChecked) {},
        activeColor: Colors.blueAccent.shade400,
        title: Text("Free Shipping", style: sproductNamBlack),
        subtitle: Text.rich(
          TextSpan(children: [
            TextSpan(text: "Delivery date : ", style: sproductNamBlack),
            TextSpan(text: " Three days after ordering ", style: ssizeinfo),
          ]),
        ),
      ),
    );
  }

  Widget paymentSection() {
    return Card(
      child: RadioListTile(
        value: 1,
        groupValue: 1,
        onChanged: (isChecked) {},
        activeColor: Colors.blueAccent.shade400,
        title: Text("Paiement when recieving", style: sproductNamBlack),
      ),
    );
  }

  Widget buildFooter(double cardWidth, BuildContext context,
      WooCustomer userData, List<CartItem> cartList) {
    var showAlert = spinkit;

    var content = Container(
      height: 50,
      width: cardWidth,
      child: Row(
        children: [
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.blueAccent.shade400,
              onLongPress: null,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                var orderCreated = await createOrder(
                    context: context, cartList: cartList, userData: userData);
                if (orderCreated == true) {
                  setState(() {
                    isLoading = false;
                    showThankYouBottomSheet(context);
                  });
                } else {
                  print("ERROR IN ORDER ");
                }
              },
              child: Text(
                "Complete the order",
                style: sproductNamBlack,
                maxLines: 1,
              ),
            ),
          ),
          isLoading ? showAlert : SizedBox.shrink()
        ],
      ),
    );
    return content;
  }

  showThankYouBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage("assets/images/ic_thank_you.png"),
                    width: 300,
                  ),
                ),
              ),
              flex: 2,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Your request has been created successfully , Thank you",
                            style: ssubleTitreNameBlack,
                          ),
                          TextSpan(
                            text: " \n Order number",
                            style: ssizeinfo,
                          ),
                          TextSpan(
                            text: "  ${orderCreated.id}  ",

                            /// todo
                            style: sproductNamBlack,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    RaisedButton(
                      onPressed: () async {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.popAndPushNamed(context, RoutingScreen.id);
                        });
                      },
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Continue shopping",
                        style: sproductNamBlack,
                      ),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }

  Widget selectedAddressSection(WooCustomer data) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12),
          child: Column(
            textDirection: TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 6,
              ),
              Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${data.shipping.firstName}",
                    style: ssizeinfo,
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 18, right: 18, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    child: Text(
                      "Home",
                      style: stitleNameBlack,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 6,
              ),
              RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(children: [
                  TextSpan(text: "tele :", style: sproductNamBlack),
                  TextSpan(
                      text: "${data.billing.phone}", style: sproductNamBlack),
                ]),
              ),
              RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(children: [
                  TextSpan(text: "Adresse :", style: sproductNamBlack),
                  TextSpan(
                      text: "${data.shipping.address1}",
                      style: sproductNamBlack),
                ]),
              ),
              RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(children: [
                  TextSpan(text: "City :", style: sproductNamBlack),
                  TextSpan(
                      text: "${data.shipping.city}", style: sproductNamBlack),
                ]),
              ),
              RichText(
                textDirection: TextDirection.ltr,
                text: TextSpan(children: [
                  TextSpan(text: "Code Postal:", style: sproductNamBlack),
                  TextSpan(
                      text: "${data.shipping.postcode}",
                      style: sproductNamBlack),
                ]),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                color: Colors.grey.shade300,
                height: 1,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget standardDelivery(List<WooShippingMethod> shippingData) {
    return Container(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: shippingData.length,
          itemBuilder: (BuildContext context, int index) {
            var shippingDataItem = shippingData[index];
            return Text("${shippingDataItem ?? "Value is null my friend ? "
                ""}");
          }),
    );
  }

  Widget checkoutItem2() {
    return Container(
      child: Consumer(builder: (context, ScopedReader watch, consumerChild) {
        final cartList = watch(cartChangeNotifierProvider).cartList;

        return Container(
          margin: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Colors.grey.shade200)),
              padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
              child: ListView.builder(
                itemBuilder: (context, position) {
                  var cartObject = cartList[position];

                  return checkoutListItem(cartObject);
                },
                itemCount: cartList.length,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget checkoutListItem(CartItem cartItem) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Container(
            child: Image(
              image: NetworkImage(
                "${cartItem.product.images[0].src}",
              ),
              width: 35,
              height: 45,
              fit: BoxFit.fitHeight,
            ),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "${cartItem.product.name}",
                      style: sproductNamBlack),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget priceSection(context) {
    return Container(
      child: Consumer(
        builder: (context, ScopedReader watch, consumerChild) {
          return Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: Colors.grey.shade200)),
                padding:
                    EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
                child: Column(
                  textDirection: TextDirection.ltr,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Order Summary",
                      style: ssubleTitreNameBlack,
                    ),
                    checkoutItem2(),
                    SizedBox(
                      height: 4,
                    ),
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      textDirection: TextDirection.ltr,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(text: "Total", style: sproductNamBlack),
                            TextSpan(text: "", style: ssizeinfo),
                          ]),
                        ),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                                text:
                                    "${context.read(cartChangeNotifierProvider).getTotalprice().toStringAsFixed(2)}",
                                style: sprice),
                            TextSpan(text: "dh", style: sproductNamBlack),
                          ]),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> createOrder(
      {BuildContext context,
      WooCustomer userData,
      List<CartItem> cartList}) async {
    List<LineItems.LineItems> cartItems = [];

    var shipingInfo = userData.shipping;
    var billingInfo = userData.billing;

    for (var cart in cartList) {
      var item = LineItems.LineItems(
        productId: cart.product.id,
        quantity: cart.quantity,
        name: cart.product.name,
      );
      cartItems.add(item);
    }
    print(cartItems.length);

    WooOrderPayload payload = WooOrderPayload(
        customerId: userData.id,
        shipping: WooOrderPayloadShipping(
          firstName: shipingInfo.firstName,
          lastName: shipingInfo.lastName,
          postcode: shipingInfo.postcode,
          city: shipingInfo.city,
          country: shipingInfo.country,
          address2: shipingInfo.address2,
          address1: shipingInfo.address1,
          state: shipingInfo.state,
        ),
        billing: WooOrderPayloadBilling(
          firstName: billingInfo.firstName,
          lastName: billingInfo.lastName,
          address1: billingInfo.address1,
          address2: billingInfo.address2,
          country: billingInfo.country,
          state: billingInfo.state,
          city: billingInfo.city,
          postcode: billingInfo.postcode,
          email: billingInfo.email,
          phone: billingInfo.phone,
        ),
        shippingLines: [],
        lineItems: cartItems,
        paymentMethod: "cod",
        paymentMethodTitle: "Paiement when recieving",
        setPaid: false,
        currency: "SAR");

    orderCreated = await WooCommerceApi().createOrder(payload);

    if (orderCreated != null) {
      return true;
    }
    return false;
  }
}
