import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_app/components/genre_card.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/User.dart';
import 'package:movie_app/models/globalV.dart';
import 'package:provider/src/provider.dart';

import '../../../constants.dart';

class Genres extends StatefulWidget {
  String urlF;
  final Function(String) onGenreSelected;
  Genres({Key key, this.urlF, this.onGenreSelected}) : super(key: key);

  @override
  _GenresState createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  int selected_genre;
  Future<List<dynamic>> getCinemas() async {
    var listCin;
    var res = await http.get(
      Uri.parse(widget.urlF),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer "+context.read<User>().token

      },
    ).then((value) {
      setState(() {
        listCin = json.decode(value.body)["_embedded"]["cinemas"];
      });
    }).catchError((onError) {
      log("error in home/components/genres  =" + onError.toString());
    });
    return listCin;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        height: 36,
        child: FutureBuilder<List<dynamic>>(
            future: getCinemas(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) => genreCard(
                      snapshot.data[index]["name"],
                      snapshot.data[index]["_links"]["salles"]["href"],
                      index),
                );
              } else
                return CircularProgressIndicator();
            }));
  }

  Widget genreCard(String genre, String urlS, int index) {
    return GestureDetector(
      onTap: () {
        widget.onGenreSelected(urlS);
        setState(() {
          selected_genre = index;
        });
      },
      child: Container(
        
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: kDefaultPadding),
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 4, // 5 padding top and bottom
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(20),
          color:  selected_genre != index? Colors.white:Colors.blue[200],
        ),
        child: Text(
          genre,
          style: TextStyle(color: selected_genre != index? kTextColor.withOpacity(0.8):Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}
