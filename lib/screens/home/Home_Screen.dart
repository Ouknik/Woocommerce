import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/screens/authentification/login/Login.dart';
import 'package:woocomerce/screens/cart/CartScreen.dart';
import 'package:woocomerce/screens/favorite/FavoriateScreen.dart';
import 'package:woocomerce/screens/profile/Profile%20Screen.dart';
import 'package:woocomerce/utili/Style.dart';
import 'package:woocomerce/data/providers/providers.dart';
import 'package:woocomerce/screens/home/homeWidgets/CateogriesItem.dart';
import 'package:woocomerce/screens/home/homeWidgets/ProudctsItem.dart';
import 'package:woocomerce/screens/home/homeWidgets/SectionsTitles.dart';
import 'package:woocomerce/screens/home/homeWidgets/slider.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../config.dart';

class HomeScreen extends ConsumerWidget {
  static final id = "HomeScreen";

  @override
  Widget build(
    BuildContext context,
    ScopedReader watch,
  ) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    final homeProvider = watch(productsCategoriesProvider);

    Future<Widget> loadFromFuture() async {
      // await Future.delayed(Duration(seconds: 5));
      final isLogged = await WooCommerceApi().checkLogged();
      if (isLogged) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProfileScreen();
        }));
      } else {
        Fluttertoast.showToast(
            msg: "you ned to login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    }

    Future<Widget> loadFromFuture2() async {
      final isLogged = await WooCommerceApi().checkLogged();
      if (isLogged) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return CartScreen();
        }));
      } else {
        Fluttertoast.showToast(
            msg: "you ned to login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.black,
            fontSize: 16.0);
      }
    }

    return Scaffold(
       
        drawer: Drawer(
          child: Scaffold(
            backgroundColor: BacgroundColors,
            body: ListView(
              children: <Widget>[
                new UserAccountsDrawerHeader(
                  accountEmail: Text(''),
                  accountName: Text(MyStor),
                  arrowColor: Colors.red,
                  currentAccountPicture: Image.asset(logo),
                ),
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return HomeScreen();
                      }));
                    },
                    child: ListTile(
                      title: Text('Home Page',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.home),
                    )),
                InkWell(
                    onTap: () {
                      loadFromFuture();
                    },
                    child: ListTile(
                      title: Text('My Account',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.person),
                    )),
                InkWell(
                    onTap: () {
                      loadFromFuture2();
                    },
                    child: ListTile(
                      title: Text('Shipping Cart',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.shopping_cart),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return CartScreen();
                      }));
                    },
                    child: ListTile(
                      title: Text('The Store',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.store),
                    )),
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return FavoraiteScreen();
                      }));
                    },
                    child: ListTile(
                      title: Text('Favourites',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.favorite),
                    )),
                InkWell(
                    onTap: () async {
                      var test = await WooCommerceApi.prodMode.logUserOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                    },
                    child: ListTile(
                      title: Text('Logout',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.logout),
                    )),
                Divider(),
                InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('Settings',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.settings),
                    )),
                InkWell(
                    onTap: () {},
                    child: ListTile(
                      title: Text('About',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                      leading: Icon(Icons.help, color: Colors.blue),
                    )),
              ],
            ),
          ),
        ),
        appBar: new AppBar(
          backgroundColor: SectionTitleColors,
          title: new Text("MyAPP"),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            return context.refresh(productsCategoriesProvider);
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                CategoriesItem(),
                SizedBox(
                  height: 10,
                ),
                TopSlider(),
                SizedBox(
                  height: 10,
                ),
                _productsData(homeProvider),
              ],
            ),
          ),
        ));
  }

  Widget SectionAndProduct(SectionsTitles sec, ProductItem productItem) {
    return Container(
      color: BacgroundColors,
      height: 420,
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Container(
              child: sec,
              height: 50,
              width: double.infinity,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: productItem,
            height: 350,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _productsData(categoriesProviderData) {
    final a = categoriesProviderData.map(data: (asyncData) {
      var listOfcats = asyncData.value;

      final catTitle = Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10.0),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listOfcats.length,
          itemBuilder: (BuildContext context, int index) {
            return SectionAndProduct(
                SectionsTitles(listOfcats[index].id.toString()),
                ProductItem(listOfcats[index].id.toString()));
          },
        ),
      );

      return catTitle;
    }, loading: (_) {
      return spinkit;
    }, error: (e) {
      return Text(e.toString());
    });
    return a;
  }
}
