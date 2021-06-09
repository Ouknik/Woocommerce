import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:woocomerce/config.dart';
import 'package:woocomerce/data/servives/WooCommerceApi.dart';
import 'package:woocomerce/utili/Constants.dart';
import 'package:woocomerce/utili/Style.dart';
import 'dart:math' show Random;
import 'package:woocommerce/woocommerce.dart';

class TopSlider extends StatefulWidget {
  @override
  _TopSliderState createState() => _TopSliderState();
}

class _TopSliderState extends State<TopSlider> {
  Widget list() {
    final s = FutureBuilder<dynamic>(
        future: WooCommerceApi().getProductsRealDamain(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return spinkit;
          }
          return AllProductsList(snapshot.data);
        });
    return s;
  }

  Widget AllProductsList(List<WooProduct> data) {
    var productImage = ImageVide;
    var hasImage = data[Random().nextInt(data.length)].images.length > 0;
    if (hasImage) {
      productImage = data[Random().nextInt(data.length)].images[0].src;
    } else {
      productImage = ImageVide;
    }

    final imageList = [
      productImage,
    ];
    return Column(
      children: [
        Container(
          color: ContanairColors,
          child: CarouselSlider(
            items: imageList.map((e) {
              return CachedNetworkImage(
                imageUrl: e ?? '',
                height: 120,
                fit: BoxFit.contain,
              );
            }).toList(),
            options: CarouselOptions(
              height: 150.0,
              aspectRatio: 5.0,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 6),
              autoPlayAnimationDuration: Duration(milliseconds: 500),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (index, next) {
                setState(() {
                  _current = index;
                });
              },
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ],
    );
  }

  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return list();
  }
}
