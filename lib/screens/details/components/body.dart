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
  final Function(int) onheureSelected;
  const Body({Key key, this.movie, this.onheureSelected}) : super(key: key);
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int postion = 0;
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
                    onPressed: () {
                      setState(() {
                        postion = (widget.movie.projection as List<dynamic>)
                            .indexOf(e);
                        widget.onheureSelected(postion);
                      });
                    },
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
              child: FutureBuilder<dynamic>(
                  future: getTicketLenght(widget.movie, postion),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      );
                    }
                    return CircularProgressIndicator();
                  }),
            ),
          ),
          //CastAndCrew(casts: movie.cast),
        ],
      ),
    );
  }

  getTicketLenght(Movie movie, int postion) async {
    int i = 0;
    for (var item in movie.projection[postion]["tickets"]) {
      if (item["reservee"] == false) i++;
    }
    setState(() {});
    return i.toString();
  }
}
