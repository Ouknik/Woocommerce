import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get/get.dart';
import 'package:woocomerce/utili/Style.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocommerce/models/order.dart';

class OrdersScreen extends ConsumerWidget {
  static final id = "ProfileScreen";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int id_user;
  OrdersScreen(this.id_user);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    double cardWidth = MediaQuery.of(context).size.width;
    final orders = watch(ordersProvider);

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Orders"),
          ),
          body: _ordersData(context, orders, cardWidth)),
    );
  }

  Widget buildContainer(
      BuildContext context, double cardWidth, List<WooOrder> _orders) {
    var taile = 0;
    return Container(
      color: BacgroundColors,
      width: cardWidth,
      child: Container(
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(
            thickness: 1,
            color: BacgrountItemCategoriest,
          ),
          padding: EdgeInsets.symmetric(horizontal: 1.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _orders.length,
          itemBuilder: (BuildContext context, int index) {
            WooOrder cartObject;

            if (_orders[index].customerId == id_user) {
              cartObject = _orders[index];
            }
            var a = DateTime.parse(cartObject.dateCreated);
            var date = "${a.day}-${a.month}-${a.year}";
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                color: CardColors,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Statue:",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.status}',
                            style: OrderStyle,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "N° de demande :",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.number}',
                            style: OrderStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Date :",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${date}',
                            style: OrderStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "N° user :",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.customerId}',
                            style: OrderStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "N° phone :",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.billing.phone}',
                            style: OrderStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Adresse1 :",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.shipping.address1}',
                            style: OrderStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Adresse2 :",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.customerIpAddress}',
                            style: OrderStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "City :",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.shipping.city}',
                            style: OrderStyle,
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "shipping fee : ",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.shippingTotal}',
                            style: OrderStyle,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total : ",
                            style: sproductNamBlack,
                          ),
                          Text(
                            '${cartObject.total} dh',
                            style: sprice,
                          ),
                        ],
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
  }

  Widget _ordersData(context, AsyncValue orders, cardWidth) {
    var body1 = orders.when(data: (asyncData) {
      List<WooOrder> _order = asyncData;

      return buildContainer(context, cardWidth, _order);
    }, loading: () {
      return spinkit;
    }, error: (error, e) {
      return Text(error.toString());
    });
    return body1;
  }
}
