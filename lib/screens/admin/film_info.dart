import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/User.dart';
import 'package:movie_app/models/globalV.dart';
import 'package:provider/src/provider.dart';

class FilmInfo extends StatefulWidget {
  bool update = false;
  dynamic data;
  FilmInfo({Key key, this.update, this.data}) : super(key: key);

  @override
  _FilmInfoState createState() => _FilmInfoState();
}

class _FilmInfoState extends State<FilmInfo> {
  bool processing = false;
  String message = "";
  TextEditingController titre,
      duree,
      realisateur,
      description,
      imageName,
      dateSortie,
      idcont,
      categorie = new TextEditingController();
  final keyFormS = GlobalKey<FormState>();
  var hint = "Categories";
  int CategId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titre = new TextEditingController();
    dateSortie = new TextEditingController();
    duree = new TextEditingController();
    realisateur = new TextEditingController();
    description = new TextEditingController();
    imageName = new TextEditingController();
    dateSortie = new TextEditingController();
    categorie = new TextEditingController();
    idcont = new TextEditingController();
    if (widget.update == true) {
      titre.text = widget.data["titre"];
      dateSortie.text = widget.data["dateSortie"];
      duree.text = widget.data["duree"].toString();
      realisateur.text = widget.data["realisateur"];
      description.text = widget.data["description"];
      imageName.text = widget.data["photo"].toString();
      idcont.text = widget.data["id"].toString();
      if (widget.data["categorie"] != null)
        hint = widget.data["categorie"]["name"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    widget.update ? "Update Movie" : "Add Movie",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "accuracy is key",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
              Form(
                key: keyFormS,
                child: Column(children: <Widget>[
                  if (widget.update)
                    makeInput2(
                        label: "id", controller: idcont, read: widget.update),
                  makeInput2(label: "titre", controller: titre),
                  makeInput2(
                      label: "duree",
                      controller: duree,
                      keyboardType: TextInputType.number),
                  makeInput2(label: "realisateur", controller: realisateur),
                  makeInput2(label: "description", controller: description),
                  makeInput2(label: "image name", controller: imageName),
                  makeInput2(
                      label: "date sortie",
                      controller: dateSortie,
                      keyboardType: TextInputType.datetime,
                      read: true),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 40,
                      child: FutureBuilder<dynamic>(
                          future: getListCategories(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return DropdownButton<String>(
                                hint: Text(hint),
                                items: snapshot.data
                                    .map<DropdownMenuItem<String>>((value) {
                                  return DropdownMenuItem<String>(
                                    value: value["name"],
                                    child: Text(value["name"].toString()),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  print(value.toString());
                                  var currentC = value.toString();
                                  setState(() {
                                    hint = value;
                                  });
                                  for (var item in snapshot.data) {
                                    if (item["name"] == value) {
                                      log(item["name"]);
                                      setState(() {
                                        CategId = item["id"];
                                        log(CategId.toString());
                                      });
                                    }
                                  }
                                },
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ]),
              ),
              Container(
                padding: EdgeInsets.only(top: 2, left: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[700]),
                      top: BorderSide(color: Colors.grey[700]),
                      left: BorderSide(color: Colors.grey[700]),
                      right: BorderSide(color: Colors.grey[700]),
                    )),
                child: MaterialButton(
                  height: 60,
                  minWidth: double.infinity,
                  onPressed: () {
                    final isValid = keyFormS.currentState.validate();
                    if (isValid) {
                      keyFormS.currentState.save();
                      widget.update
                          ? updateFilm(widget.data["id"])
                          : addFilm(CategId);
                      /*context.read<AuthenticationService>().signUp(
                            email: emailctrl.text.trim(),
                            password: passctrl.text.trim(),
                            firstName: firstnamectrl.text.trim(),
                            lastName: lastnamectrl.text.trim());*/

                      //  AuthenticationService(FirebaseAuth.instance);
                    }
                  },
                  color: Colors.black.withOpacity(0.9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: processing == false
                      ? Text(
                          widget.update ? "Update Movie" : "Add Movie",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white),
                        )
                      : CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget makeInput2(
      {label,
      obscureText = false,
      controller,
      keyboardType = TextInputType.text,
      read: false}) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              )),
          SizedBox(
            height: 5,
          ),
          TextFormField(
              readOnly: read,
              keyboardType: keyboardType,
              onTap: () async {
                if (keyboardType == TextInputType.datetime) {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1960),
                      initialDate: DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    dateSortie.text = date.toString();
                  }
                }
              },
              // validator: Validator.validateFirstName,
              obscureText: obscureText,
              controller: controller,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400])),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400])),
              )),
          SizedBox(
            height: 30,
          )
        ]);
  }

  addFilm(int id) async {
    var body;
    if (hint.toString() == "Categories")
      body = json.encode({
        "titre": titre.text,
        "realisateur": realisateur.text,
        "description": description.text,
        "photo": imageName.text,
        "dateSortie": dateSortie.text,
        "duree": int.parse(duree.text)
      });
    else
      body = json.encode({
        "titre": titre.text,
        "realisateur": realisateur.text,
        "description": description.text,
        "photo": imageName.text,
        "dateSortie": dateSortie.text,
        "duree": int.parse(duree.text),
        "categorie": {"name": hint.toString(), "id": id}
      });

    log(body);
    final res = await http.post(Uri.parse(GlobalV.url + "addFilm"),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + context.read<User>().token
        });
    if (res.statusCode == 200) {
      log("status 200");
      Navigator.pop(context);
    } else
      log("status is not ok");
  }

  updateFilm(int id) async {
    var body;
    if (hint.toString() == "Categories")
      body = json.encode({
        "titre": titre.text,
        "realisateur": realisateur.text,
        "description": description.text,
        "photo": imageName.text,
        "dateSortie": dateSortie.text,
        "duree": double.parse(duree.text),
        "id": id
      });
    else
      body = json.encode({
        "titre": titre.text,
        "realisateur": realisateur.text,
        "description": description.text,
        "photo": imageName.text,
        "dateSortie": dateSortie.text,
        "duree": double.parse(duree.text),
        "id": id,
        "categorie": {"name": hint,"id":CategId}
      });

    log(body);
    final res = await http.put(Uri.parse(GlobalV.url + "updateFilm"),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer " + context.read<User>().token
        });
    if (res.statusCode == 200) {
      log("status 200");
      Navigator.pop(context);
    } else
      log("status is not ok");
  }

  getListCategories() async {
    var cataegList;
    var res = await http.get(
      Uri.parse(GlobalV.url+"allCategories"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer " + context.read<User>().token
      },
    ).then((value) {
      if (this.mounted) {
        setState(() {
          cataegList = json.decode(value.body);
        });
      }
    }).catchError((onError) {
      log("error in home/components/film info getList Categories  =" +
          onError.toString());
    });
    return cataegList;
  }
}
