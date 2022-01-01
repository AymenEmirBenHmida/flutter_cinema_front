import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movie_app/models/User.dart';
import 'package:movie_app/models/globalV.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/details/components/Book_ticket.dart';
import 'package:movie_app/screens/details/components/body.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/provider.dart';
import '../../constants.dart';

class DetailsScreen extends StatefulWidget {
  Movie movie;
  String urlP;

  DetailsScreen({Key key, this.movie, this.urlP}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int position = 0;
  Future<List<dynamic>> getCinemas() async {
    var listCin;
    print(widget.urlP);
    var res = await http.get(
      Uri.parse(widget.urlP),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + context.read<User>().token
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
          future: getCinemas(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // setState(() {
              widget.movie = new Movie(
                  poster: GlobalV.url +
                      "imageFilm/" +
                      snapshot.data[0]["film"]["id"].toString(),
                  backdrop: GlobalV.url +
                      "imageFilm/" +
                      snapshot.data[0]["film"]["id"].toString(),
                  title: snapshot.data[0]["film"]["titre"],
                  rating: double.parse(snapshot.data[0]["film"]["titre"]
                              .toString()
                              .length
                              .toString()) >
                          10
                      ? 8.6
                      : double.parse(snapshot.data[0]["film"]["titre"]
                          .toString()
                          .length
                          .toString()),
                  plot: snapshot.data[0]["film"]["description"] == null
                      ? "the description has not been uploaded yet sorry"
                      : snapshot.data[0]["film"]["description"],
                  year: snapshot.data[0]["film"]["dateSortie"] == null
                      ? 1984
                      : int.parse(snapshot.data[0]["film"]["dateSortie"]),
                  projection: snapshot.data);
              //  });
              return Body(
                movie: new Movie(
                    poster: GlobalV.url +
                        "imageFilm/" +
                        snapshot.data[0]["film"]["id"].toString(),
                    backdrop: GlobalV.url +
                        "imageFilm/" +
                        snapshot.data[0]["film"]["id"].toString(),
                    title: snapshot.data[0]["film"]["titre"],
                    rating: double.parse(snapshot.data[0]["film"]["titre"]
                                .toString()
                                .length
                                .toString()) >
                            10
                        ? 8.6
                        : double.parse(snapshot.data[0]["film"]["titre"]
                            .toString()
                            .length
                            .toString()),
                    plot: snapshot.data[0]["film"]["description"] == null
                        ? "the description has not been uploaded yet sorry"
                        : snapshot.data[0]["film"]["description"],
                    year: snapshot.data[0]["film"]["dateSortie"] == null
                        ? 1984
                        : int.parse(snapshot.data[0]["film"]["dateSortie"]),
                    projection: snapshot.data),
                onheureSelected: (heure) {
                  setState(() {
                    position = heure;
                  });
                },
              );
            }
            return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Book_ticket(widget.movie, position)));
        },
        label: Text(
          "Reserve a Ticket",
          style: TextStyle(fontSize: 25),
        ),
        backgroundColor: Colors.lightGreen,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
