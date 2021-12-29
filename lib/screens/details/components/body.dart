import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_app/constants.dart';
import 'package:movie_app/models/movie.dart';

import 'backdrop_rating.dart';
import 'cast_and_crew.dart';
import 'genres.dart';
import 'title_duration_and_fav_btn.dart';
class Body extends StatefulWidget {
final Movie movie;

  const Body({Key key, this.movie}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
 @override
  Widget build(BuildContext context) {
    // it will provide us total height and width
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BackdropAndRating(size: size, movie: widget.movie),
          SizedBox(height: kDefaultPadding / 2),
          TitleDurationAndFabBtn(movie: widget.movie),
          //Genres(movie: movie),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "Description Summary",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(
              widget.movie.plot,
              style: TextStyle(
                color: Color(0xFF737599),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 40, left: 20, bottom: 20),
            child: Text(
              "Playing times",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),

          Row(
            children: [
              ...(widget.movie.projection as List<dynamic>).map((e) {
                return SizedBox(
                  width: size.width / widget.movie.projection.length,
                  child: RaisedButton(
                    onPressed: () {},
                    child: Text("${e['seance']['heureDebut']} "),
                  ),
                );
              })
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: kDefaultPadding / 2,
              horizontal: kDefaultPadding,
            ),
            child: Text(
              "Number of tickets remaining",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: kDefaultPadding / 2,
                horizontal: kDefaultPadding,
              ),
              child: Text(
                getTicketLenght(widget.movie),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          //CastAndCrew(casts: movie.cast),
        ],
      ),
    );
  }
  
  getTicketLenght(Movie movie) {
    int i = 0;
    for (var item in movie.projection[0]["tickets"]) {
      if (item["reservee"] == false) i++;
    }
    return i.toString();
  }
}
