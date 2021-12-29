import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/models/User.dart';
import 'package:movie_app/models/globalV.dart';
import 'package:provider/src/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';

import '../../constants.dart';

class Adminwelcome extends StatefulWidget {
  const Adminwelcome({Key key}) : super(key: key);

  @override
  _AdminwelcomeState createState() => _AdminwelcomeState();
}

class _AdminwelcomeState extends State<Adminwelcome> {
  getCinemas() async {
    var listCin;
    print("entered");
    var res = await http.get(
      Uri.parse(GlobalV.urlReserved),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + context.read<User>().token
      },
    );
    // print(res.statusCode.toString() + "body");
    print(res.statusCode.toString() + "body");
    listCin = json.decode(res.body);
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
      body: Container(
          margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: FutureBuilder<dynamic>(
              future: getCinemas(),
              builder: (context, snapshot) {
                if (snapshot.data.length == 0)
                  return Center(
                    child: Text(
                      "No reservations yet.",
                      style: TextStyle(fontSize: 30),
                    ),
                  );
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) =>
                        genreCard(snapshot.data[index]),
                  );
                } else
                  return CircularProgressIndicator();
              })),
    );
  }

  Widget genreCard(dynamic data) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        deleteTicket(data["id"].toString());
      },
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("id:"),
                        Text("date:"),
                        Text("nom Client:"),
                        Text("nom Film:")
                      ]),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 100),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(" ${data["id"]}"),
                        Text(
                            " ${data["projection"]["dateProjection"].toString().substring(0, 10)}"),
                        Text(" ${data["nomClient"]}"),
                        Text(" ${data["projection"]["film"]["titre"]}")
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteTicket(String id) async {
    var res = await http.delete(
      Uri.parse(GlobalV.urlT + "/" + id),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + context.read<User>().token
      },
    );
    log(res.statusCode.toString() + "status code delete");
    // print(res.statusCode.toString() + "body");
  }
}
