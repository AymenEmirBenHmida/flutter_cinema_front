import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_app/components/genre_card.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/home/components/salle.dart';
import 'dart:math' as math;

import 'categories.dart';
import 'genres.dart';
import 'movie_card.dart';
import 'movie_carousel.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String urlF = "";
  String urlS = "";
  String urlP = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Categorylist(onCategorySelected: (String a) {
            setState(() {
              urlF = a;
            });
          }),
          if (urlF != "")
            Genres(
              urlF: urlF,
              onGenreSelected: (String a) {
                setState(() {
                  urlS = a;
                });
              },
            ),
          if (urlS != "")
            SalleList(
              urlS: urlS,
              onSalleSelected: (String a) {
                setState(() {
                  urlP = a;
                  log("urlp ="+urlP);
                });
              },
            ),
          SizedBox(height: kDefaultPadding),
          if (urlP != "")
            MovieCarousel(urlP:urlP)
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: Center(
                  child: Text(
                "Choose wisely ^^",
                style: TextStyle(fontSize: 40),
              )),
            )
        ],
      ),
    );
  }
}
