import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:woocomerce/utili/Style.dart';

class CheckoutCard extends ConsumerWidget {
  const CheckoutCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Material(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: (15),
          horizontal: (10),
        ),
        // height: 174,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, -15),
              blurRadius: 20,
              color: Color(0xFFDADADA).withOpacity(0.15),
            )
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    height: (40),
                    width: (40),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F6F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.receipt,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "add cobone",
                    style: ssubleTitreNameBlack,
                  ),
                  Icon(
                    Icons.arrow_back_ios_outlined,
                    size: 12,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),

                  // todo  Fix keyboard
                  Expanded(
                    child: TextFormField(
                      textDirection: TextDirection.ltr,
                      decoration: InputDecoration(
                        labelText: 'Cobone',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        hintText: 'Cobone',
                      ),
                      validator: (input) => input.trim().length < 3
                          ? 'Please enter a valid name'
                          : null,
                      // onSaved: (input) => _name = input,
                    ),
                  ),
                ],
              ),
              SizedBox(height: (20)),
              Row(
                textDirection: TextDirection.ltr,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // color: Colors.red,
                    child: Center(
                      child: Text.rich(
                        TextSpan(
                          style: sproductNamBlack,
                          text: "totale \n ",
                          children: [
                            TextSpan(text: 'dh', style: sproductNamBlack),
                            TextSpan(
                              // todo calculate total
                              text: " 337.15",
                              style: sprice,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      // padding: EdgeInsets.symmetric(horizontal: 10),
                      // height: (40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: FlatButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        color: Colors.green[500],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          // context.read(productsChangeNotifierProvider).addQuantity();
                        },
                        child: Text(
                          "Paying",
                          style: sproductNamBlack,
                        ),
                      ),
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
