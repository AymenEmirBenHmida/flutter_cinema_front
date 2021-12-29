import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_app/models/User.dart';
import 'package:movie_app/models/globalV.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/screens/home/components/movie_card.dart';
import 'package:provider/src/provider.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';
import 'film_info.dart';
import 'movieCardAdmin.dart';

class films extends StatefulWidget {
  const films({Key key}) : super(key: key);

  @override
  _filmsState createState() => _filmsState();
}

class _filmsState extends State<films> {
  Future<dynamic> getCinemas() async {
    var listCin;
    var res = await http.get(
      Uri.parse(GlobalV.urlF),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + context.read<User>().token
      },
    );
    if (mounted){
    setState(() {
     listCin = json.decode( utf8.decode(res.bodyBytes));

    });}
    return listCin;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("entered admin welcome page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FilmInfo(update: false,)));
        },
      ),
      body: Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: FutureBuilder<dynamic>(
              future: getCinemas(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) =>
                        genreCard(snapshot.data[index], context),
                  );
                } else
                  return CircularProgressIndicator();
              })),
    );
  }

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        await deleteFilm(id);
        setState(() {});
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("would you like to continue and delete this film?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget genreCard(dynamic data, BuildContext context) {
    return GestureDetector(
        onTap: () {
          showAlertDialog(context, data["id"].toString());
        },
        onDoubleTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => FilmInfo(data: data,update: true,))
          );
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 3.5,
          width: MediaQuery.of(context).size.width / 2.5,
          child: MovieCardAdmin(
            movie: new Movie(
                poster: GlobalV.url + "imageFilm/" + data["id"].toString(),
                title: data["titre"],
                rating: 8.5),
          ),
        ));
  }

  deleteFilm(String id) async {
    var res = await http.delete(
      Uri.parse(GlobalV.urlF1 + "/" + id),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + context.read<User>().token
      },
    );
    log(res.statusCode.toString() + "status code delete");
    print(res.statusCode);
    // print(res.statusCode.toString() + "body");
    return "";
  }
}
