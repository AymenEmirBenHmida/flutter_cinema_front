import 'dart:convert';
import 'dart:developer';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_app/models/User.dart';
import 'package:movie_app/models/globalV.dart';

import 'dart:math';

import 'package:movie_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/provider.dart';

import '../../../constants.dart';
import 'movie_card.dart';

class MovieCarousel extends StatefulWidget {
  String urlP;
  MovieCarousel({this.urlP});

  @override
  _MovieCarouselState createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  PageController _pageController;
  int initialPage = 0;
  Random random = new Random();

  Future<List<dynamic>> getCinemas() async {
    var listCin;
    print(widget.urlP);
    var res = await http.get(
      Uri.parse(widget.urlP),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer "+context.read<User>().token

      },
    ).then((value) {
      setState(() {
        listCin = json.decode(value.body)["_embedded"]["projections"];
      });
    }).catchError((onError) {
      //log("error in home/components/salle  =" + onError.toString());
    });
    return listCin;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      // so that we can have small portion shown on left and right side
      viewportFraction: 0.8,
      // by default our movie poster
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: AspectRatio(
          aspectRatio: 0.85,
          child: FutureBuilder<List<dynamic>>(
              future: getCinemas(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          initialPage = value;
                        });
                      },
                      controller: _pageController,
                      physics: ClampingScrollPhysics(),
                      itemCount: 1, // we have 3 demo movies
                      itemBuilder: (context, index) => buildMovieSlider(
                          index,
                          snapshot.data[index]["film"],
                          new Movie(
                            poster: GlobalV.url +
                                "imageFilm/" +
                                snapshot.data[index]["film"]["id"].toString(),
                            backdrop: GlobalV.url +
                                "imageFilm/" +
                                snapshot.data[index]["film"]["id"].toString(),
                            title: snapshot.data[index]["film"]["titre"],
                            rating: double.parse(snapshot.data[index]["film"]
                                            ["titre"]
                                        .toString()
                                        .length
                                        .toString()) >
                                    10
                                ? 8.6
                                : double.parse(snapshot.data[index]["film"]
                                        ["titre"]
                                    .toString()
                                    .length
                                    .toString()),
                                    plot: snapshot.data[index]["film"]["description"]==null?"the description has not been uploaded yet sorry":snapshot.data[index]["film"]["description"],
                                    year: snapshot.data[index]["film"]["dateSortie"]==null?1984:int.parse(snapshot.data[index]["film"]["dateSortie"]),
                                    projection: snapshot.data
                          )));
                }
                return Center(
                    child: Text(
                  "Choose wisely ^^",
                  style: TextStyle(fontSize: 40),
                ));
              })),
    );
  }

  Widget buildMovieSlider(int index, data, Movie mov) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0;
        if (_pageController.position.haveDimensions) {
          value = index - _pageController.page;
          // We use 0.038 because 180*0.038 = 7 almost and we need to rotate our poster 7 degree
          // we use clamp so that our value vary from -1 to 1
          value = (value * 0.038).clamp(-1, 1);
        }
        return AnimatedOpacity(
          duration: Duration(milliseconds: 350),
          opacity: initialPage == index ? 1 : 0.4,
          child: Transform.rotate(
            angle: pi * value,
            child: MovieCard(movie: mov,urlP:widget.urlP),
          ),
        );
      },
    );
  }
}
