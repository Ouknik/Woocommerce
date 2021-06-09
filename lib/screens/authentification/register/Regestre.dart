import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:woocomerce/config.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/screens/authentification/login/Login.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocommerce/models/customer.dart';
import 'package:woocomerce/utili/Style.dart';

class Regestre extends StatefulWidget {
  static final id = "SignUpPage";

  @override
  _RegestreState createState() => _RegestreState();
}

class _RegestreState extends State<Regestre> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// dalt form  ====================================================
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  TextEditingController _Tfullname;
  TextEditingController _Tlastname;
  TextEditingController _Temail;
  TextEditingController _Tusername;
  TextEditingController _Tpassword;

  //TextEditingController _Tadress1;
  //TextEditingController _Tadress2;
  //TextEditingController _TCity;
  //TextEditingController Ttele;

  String _fname;
  String _lname;
  String _email;
  String _password;
  String _username;
  //String _adress1;
  //String _adress2;
  //String _city;
  //String _tele;

  bool hidePassword = true;
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    _Tfullname = TextEditingController();
    _Tlastname = TextEditingController();
    _Temail = TextEditingController();
    _Tpassword = TextEditingController();
    _Tusername = TextEditingController();
    // _Tadress1 = TextEditingController();
    // _Tadress2=TextEditingController();
    // _TCity = TextEditingController();
    // Ttele = TextEditingController();

    this._fname = _Tfullname.text;
    this._lname = _Tlastname.text;
    this._email = _Temail.text;
    this._password = _Tpassword.text;
    this._username = _Tusername.text;

//this._adress1= _Tadress1.text;
//this._adress2= _Tadress2.text;
//this._city= _TCity.text;
//this._tele= Ttele.text;
  }

  Future<WooCustomer> createdNewCustomerFromInput() async {
    log("createdNewCustomerFromInput Called");
    final customer = WooCustomer(
      firstName: _fname,
      lastName: _lname,
      email: _email,
      password: _password,
      username: _username,
    );
    return customer;
  }

  Future<bool> createdNewCustomerInServer() async {
    final customer = await createdNewCustomerFromInput();
    setState(() {
      showSpinner = true;
    });

    final rigesterd =
        await WooCommerceApi().createCustumer(customer).whenComplete(() {
      setState(() {
        showSpinner = false;
      });

      // return Scaffold.of(context).showSnackBar(snackBar);
    }).then((value) {
      if (value == true) {
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => Login(),
          ),
        );
      }
    }).catchError((e) {});

    return rigesterd;
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
                                  local_url,
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                // height: 40.0,
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
                                "Regestre",
                                style: stitleNameBlack,
                              ),
                              SizedBox(height: 20),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: new TextFormField(
                                  controller: _Tfullname,
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.next,
                                  style: ssizeinfo,
                                  keyboardType: TextInputType.text,
                                  onSaved: (input) {
                                    return _fname = input;
                                  },
                                  decoration: new InputDecoration(
                                    labelText: "firste Name ",
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.green.withOpacity(0.2))),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    prefixIcon: Icon(
                                      Icons.receipt,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: new TextFormField(
                                  controller: _Tlastname,
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.next,
                                  style: ssizeinfo,
                                  keyboardType: TextInputType.text,
                                  onSaved: (input) => _lname = input,
                                  decoration: new InputDecoration(
                                    labelText: "Last Name",
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.green.withOpacity(0.2))),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green)),
                                    prefixIcon: Icon(
                                      Icons.receipt,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: new TextFormField(
                                  controller: _Temail,
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.next,
                                  style: ssizeinfo,
                                  keyboardType: TextInputType.emailAddress,
                                  onSaved: (input) => _email = input,
                                  validator: (input) => !input.contains('@')
                                      ? "Email is not valid"
                                      : null,
                                  decoration: new InputDecoration(
                                    labelText: 'Email',
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: new TextFormField(
                                  controller: _Tusername,
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.next,
                                  style: ssizeinfo,
                                  keyboardType: TextInputType.text,
                                  onSaved: (input) => _username = input,
                                  validator: (input) => input.length < 6
                                      ? "username > 6 charcter"
                                      : null,
                                  decoration: new InputDecoration(
                                    labelText: "username",
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.black.withOpacity(0.2))),
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
                              SizedBox(height: 30),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: new TextFormField(
                                  controller: _Tpassword,
                                  textDirection: TextDirection.ltr,
                                  textInputAction: TextInputAction.next,
                                  style: ssizeinfo,
                                  keyboardType: TextInputType.text,
                                  onSaved: (input) => _password = input,
                                  validator: (input) => input.length < 6
                                      ? "Password > 6 characters"
                                      : null,
                                  obscureText: hidePassword,
                                  decoration: new InputDecoration(
                                    labelText: "password",
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                Colors.green.withOpacity(0.2))),
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
                              GestureDetector(
                                child: Text(
                                  "I have a count",
                                  style: sproductNamBlack,
                                ),
                                onTap: () {
                                  return Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Login(),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 30),
                              FlatButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 80),
                                onPressed: () async {
                                  var isOk = await validateAndSave();

                                  if (isOk) {
                                    final customer =
                                        await createdNewCustomerInServer();
                                    if (customer is WooCustomer) {
                                      return Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Login(),
                                        ),
                                      );
                                    } else if (customer is WooCustomer) {
                                      print("HAKONA MATATA");
                                    }
                                    print(customer);
                                  } else {
                                    print(" Wrong  Inputs!!");
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    " Regestre",
                                    style: sproductNamBlack,
                                  ),
                                ),
                                color: Colors.blue,
                                shape: StadiumBorder(),
                              ),
                              SizedBox(height: 15),
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
    _Tusername.clear();
    _Tpassword.clear();
    _Temail.clear();
    _Tfullname.clear();
    _Tlastname.clear();
  }
}
