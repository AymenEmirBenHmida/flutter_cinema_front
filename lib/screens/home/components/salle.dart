import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_app/components/genre_card.dart';
import 'package:movie_app/models/User.dart';
import 'package:provider/src/provider.dart';

import '../../../constants.dart';
import '../../../models/globalV.dart';
import 'package:http/http.dart' as http;

class SalleList extends StatefulWidget {
  String urlS;
  final Function(String) onSalleSelected;
  SalleList({Key key, this.urlS, this.onSalleSelected}) : super(key: key);

  @override
  _SalleListState createState() => _SalleListState();
}

class _SalleListState extends State<SalleList> {
  int selected_salle;
  Future<List<dynamic>> getCinemas() async {
    var listCin;
    var res = await http.get(
      Uri.parse(widget.urlS),
      headers: {
        'Content-Type': 'application/json',     
       'Authorization': "Bearer "+context.read<User>().token

      },
      
    ).then((value) {
      setState(() {
        listCin = json.decode(value.body)["_embedded"]["salles"];
      });
    }).catchError((onError) {
      log("error in home/components/salle  =" + onError.toString());
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
                          index,
                          snapshot.data[index],
                        ));
              } else
                return CircularProgressIndicator();
            }));
  }

  Widget genreCard(String genre, int index, data) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected_salle = index;
          widget.onSalleSelected(data["_links"]["projections"]["href"]
              .toString()
              .replaceAll("{?projection}", "?projection=p1"));
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
          color: selected_salle != index ? Colors.white : Colors.brown[200],
        ),
        child: Text(
          genre,
          style: TextStyle(
              color: selected_salle != index
                  ? kTextColor.withOpacity(0.8)
                  : Colors.white,
              fontSize: 16),
        ),
      ),
    );
  }
}
