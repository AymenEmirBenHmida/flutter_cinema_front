import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_app/models/User.dart';
import 'package:provider/src/provider.dart';

import '../../../constants.dart';
import '../../../models/globalV.dart';
import 'package:http/http.dart' as http;

// We need stateful widget because we need to change some sate on our category
class Categorylist extends StatefulWidget {
  final Function(String) onCategorySelected;
  Categorylist({@required this.onCategorySelected});
  @override
  _CategorylistState createState() => _CategorylistState();
}

class _CategorylistState extends State<Categorylist> {
  int selectedCategory = 0;
  Future<List<dynamic>> categories;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<List<dynamic>> getCategories() async {
    var cataegList;
    var res = await http.get(
      Uri.parse(GlobalV.urlV),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer "+context.read<User>().token
      },
    ).then((value) {
      setState(() {
        cataegList = json.decode(value.body)["_embedded"]["villes"];
      });
    }).catchError((onError) {
      log("error in home/components/categories  =" + onError.toString());
    });
    return cataegList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
        height: 60,
        child: FutureBuilder<List<dynamic>>(
            future: getCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                      buildCategory(index, context, snapshot.data),
                );
              } else
                return CircularProgressIndicator();
            }));
  }

  Widget buildCategory(int index, BuildContext context, dynamic categ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: GestureDetector(
          onTap: () {
            setState(() {
              selectedCategory = index;
            });
            widget
                .onCategorySelected(categ[index]["_links"]["cinemas"]["href"]);
            log("url returned for listes cinemas in categories is = " +
                categ[index]["_links"]["cinemas"]["href"]);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                categ[index]["name"],
                style: Theme.of(context).textTheme.headline5.copyWith(
                      fontWeight: FontWeight.w600,
                      color: index == selectedCategory
                          ? kTextColor
                          : Colors.black.withOpacity(0.4),
                    ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                height: 6,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: index == selectedCategory
                      ? kSecondaryColor
                      : Colors.transparent,
                ),
              )
            ],
          )),
    );
  }
}
