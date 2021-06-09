import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/screens/ButtonNavigatorBar.dart';
import 'package:woocomerce/screens/authentification/register/Regestre.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocomerce/utili/Style.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocommerce/woocommerce.dart';
import '../../../config.dart';

class Login extends StatefulWidget {
  static final id = "LoginPage";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController username;
  TextEditingController password;
  String _password;
  String _username;

  bool hidePassword = true;
  bool showSpinner = false;

  Future<WooCustomer> loginUserLocal() async {
    log("loginUserLocal Called");
    final customer = WooCustomer(password: _password, username: _username);
    return customer;
  }

  Future<bool> loginUserServer() async {
    log("loginUserServer Called");

    setState(() {
      showSpinner = true;
    });
    var customer = await loginUserLocal();
    log(" local costumer :${customer.username}");
    final login = await WooCommerceApi()
        .loginUser(customer.username, customer.password)
        .then((value) {
      if (value != null) {
        return true;
      } else {
        print(value);
        return false;
      }
    }).catchError((e) {
      print(e);
    }).whenComplete(() => setState(() {
              showSpinner = false;
            }));
    return login;
  }

  @override
  void initState() {
    super.initState();
    password = TextEditingController();
    username = TextEditingController();

    this._password = password.text;
    this._username = username.text;
  }

  @override
  Widget build(BuildContext context) {
    return body(context);
  }

  Widget body(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.white,
      progressIndicator: spinkit,
      inAsyncCall: showSpinner,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.grey,
        body: SafeArea(
          child: Builder(
            builder: (context) => GestureDetector(
              onTap: () => hideKeyboard(context),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 40.0),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: 40.0,
                                child: Image.asset(
                                  "$local_url",
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                child: Text(
                              "$MyStor",
                              style: stitleNameBlack,
                            )),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        margin:
                            EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.yellow,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 10),
                                blurRadius: 20)
                          ],
                        ),
                        child: Form(
                          key: globalFormKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 25),
                              Text(
                                "Login",
                                style: stitleNameBlack,
                              ),
                              SizedBox(height: 20),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: new TextFormField(
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.next,
                                  style: sproductNamBlack,
                                  keyboardType: TextInputType.name,
                                  onSaved: (input) => _username = input,
                                  validator: (input) =>
                                      input.isEmpty ? "name is vid" : null,
                                  decoration: new InputDecoration(
                                    hintText: "Email or username",
                                    labelText: 'username',
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: new TextFormField(
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.next,
                                  style: sproductNamBlack,
                                  keyboardType: TextInputType.text,
                                  onSaved: (input) => _password = input,
                                  validator: (input) => input.length < 3
                                      ? "Password should be more than 3 characters"
                                      : null,
                                  obscureText: hidePassword,
                                  decoration: new InputDecoration(
                                    hintText: "password",
                                    labelText: "password",
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2))),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          hidePassword = !hidePassword;
                                        });
                                      },
                                      color: Colors.black.withOpacity(0.4),
                                      icon: Icon(hidePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Text(
                                        "forget password",
                                        style: sproductNamBlack,
                                      ),
                                      onTap: () async {
                                        await launchForgetPassworddWebView(
                                            context, forgetPasswordUrl);
                                      },
                                    ),
                                    GestureDetector(
                                      child: Text(
                                        "new a couant",
                                        style: sproductNamBlack,
                                      ),
                                      onTap: () async {
                                        return Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Regestre(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 80),
                                onPressed: () async {
                                  var isOk = await validateAndSave();

                                  if (isOk) {
                                    final customer = await loginUserServer()
                                        .whenComplete(
                                            () => showSpinner = false);

                                    if (customer != null) {
                                      return Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              RoutingScreen(),
                                        ),
                                      );
                                    } else {
                                      print(" Wrong!");
                                    }
                                  } else {
                                    print("Somthing Wrong!!");
                                  }
                                },
                                child: Text(
                                  "Login",
                                  style: sproductNamBlack,
                                ),
                                color: Colors.blue,
                                shape: StadiumBorder(),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Center(
                          child: Image.asset(
                            SingneImage,
                            width: 50,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          SingneText,
                          style: sproductNamBlack,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> validateAndSave() async {
    await Future.delayed(Duration(seconds: 0));

    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void clearForm() {
    globalFormKey.currentState.reset();
    username.clear();
    password.clear();
  }
}
