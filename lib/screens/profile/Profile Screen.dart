import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/screens/ProductScreen/productWidgets/ExpansionInfo.dart';
import 'package:woocomerce/screens/authentification/login/Login.dart';
import 'package:woocomerce/screens/favorite/FavoriateScreen.dart';
import 'package:woocomerce/utili/Style.dart';
import 'package:woocomerce/screens/profile/OrdersScreen.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocommerce/models/customer.dart';

import 'OrdersScreen.dart';

class ProfileScreen extends ConsumerWidget {
  static final id = "ProfileScreen";
  String _userName;
  String _fName;
  String _sName;
  String _email;
  String _phone;
  String _address;
  var tapped;

  bool onEtTap(tapped) {
    if (tapped == true) {
      tapped = false;
    } else {
      tapped = true;
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    AsyncValue<WooCustomer> custumerProvider = watch(usersProvider);

    var body = custumerProvider.when(data: (asynData) {
      WooCustomer data = asynData;

      var content = buildScaffold(context, data);

      return content;
    }, loading: () {
      return spinkit;
    }, error: (error, e) {
      return Text(e.toString());
    });
    return body;
  }

  Scaffold buildScaffold(BuildContext context, WooCustomer data) {
    return Scaffold(
      backgroundColor: CaderColors,
      body: RefreshIndicator(
        onRefresh: () {
          return context.refresh(usersProvider);
        },
        child: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(left: 16.0, right: 16.0, top: kToolbarHeight),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    maxRadius: 48,
                    backgroundImage:
                        NetworkImage('${data.avatarUrl}') ?? Icon(Icons.person),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '${data.username}',
                      style: stitleNameBlack,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        color: ContanairColors,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(0, 5))
                        ]),
                    height: 60,
                    child: Center(
                      child: Row(
                        textDirection: TextDirection.ltr,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            icon: Image.asset(
                              'assets/images/truck.png',
                            ),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => OrdersScreen(data.id))),
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => FavoraiteScreen())),
                          ),
                          IconButton(
                            icon: Icon(Icons.help),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.logout),
                            onPressed: () async {
                              var test =
                                  await WooCommerceApi.prodMode.logUserOut();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    color: CardColors,
                    child: Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: ExpansionInfo(
                            text: Text(
                              "Profile",
                              style: stitleNameBlack,
                            ),
                            expand: true,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: Icon(
                                            Icons.drive_file_rename_outline),
                                        title: Text(data.billing.firstName),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        onTap: () {
                                          return showEditDialoag(
                                            context: context,
                                          );
                                        },
                                        leading: Icon(Icons.email),
                                        title: Text(data.billing.email),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: Icon(Icons.call),
                                        title: Text(data.billing.phone),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: Icon(Icons.add_location),
                                        title: Text(data.billing.address1),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: Icon(Icons.add_location),
                                        title: Text(data.billing.address2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GlobalKey<FormState> _formkey = GlobalKey();

  Widget FormUi(BuildContext context, WooCustomer data) {
    return Container(
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            /// USER INFO
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: data.firstName,
                  enabled: tapped,
                  onTap: () {
                    return onEtTap;
                  },
                  maxLength: 32,
                  keyboardType: TextInputType.text,
//                controller: _textFieldControllerName,
                  maxLines: 1,
                  style: sproductNamBlack,
                  decoration: InputDecoration(
                    labelText: "full name : ",
                    icon: Icon(Icons.person),
                  ),
                  textDirection: TextDirection.ltr,
                  onSaved: (String val) {
                    _fName = val;
                  },
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: data.lastName,
                  enabled: tapped,
                  onTap: () {
                    return onEtTap;
                  },
                  maxLength: 32,
                  keyboardType: TextInputType.text,
//                controller: _textFieldControllerName,
                  maxLines: 1,
                  style: sproductNamBlack,
                  decoration: InputDecoration(
                    labelText: "last name :",
                    icon: Icon(Icons.person),
                  ),
                  textDirection: TextDirection.ltr,
                  onSaved: (String val) {
                    _fName = val;
                  },
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: data.username,
                  enabled: tapped,
                  onTap: () {
                    return onEtTap;
                  },
                  maxLength: 32,
                  keyboardType: TextInputType.text,
//                controller: _textFieldControllerName,
                  maxLines: 1,
                  style: sproductNamBlack,
                  decoration: InputDecoration(
                    labelText: "udername :",
                    icon: Icon(Icons.person),
                  ),
                  textDirection: TextDirection.ltr,
                  onSaved: (String val) {
                    _fName = val;
                  },
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: data.email,
                  enabled: tapped,
                  onTap: () {
                    return onEtTap;
                  },
                  maxLength: 32,
                  keyboardType: TextInputType.text,
//                controller: _textFieldControllerName,
                  maxLines: 1,
                  style: sproductNamBlack,
                  decoration: InputDecoration(
                    labelText: "email : ",
                    icon: Icon(Icons.person),
                  ),
                  textDirection: TextDirection.ltr,
                  onSaved: (String val) {
                    _fName = val;
                  },
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: data.shipping.address1,
                  enabled: tapped,
                  onTap: () {
                    return onEtTap;
                  },
                  maxLength: 32,
                  keyboardType: TextInputType.text,
//                controller: _textFieldControllerName,
                  maxLines: 1,
                  style: sproductNamBlack,
                  decoration: InputDecoration(
                    labelText: "adresse :",
                    icon: Icon(Icons.person),
                  ),
                  textDirection: TextDirection.ltr,
                  onSaved: (String val) {
                    _fName = val;
                  },
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  showEditDialoag({BuildContext context, wooCustomer}) async {}
}
