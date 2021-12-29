import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/models/User.dart';
import 'package:movie_app/models/movie.dart';
import 'package:http/http.dart' as http;
import 'package:provider/src/provider.dart';
import '../../../models/globalV.dart';

class Book_ticket extends StatefulWidget {
  Movie movie;
  Book_ticket(this.movie);

  // This widget is the root of your application.
  @override
  Book_ticket1 createState() => Book_ticket1();
}

class Book_ticket1 extends State<Book_ticket> {
  bool processing = false;
  String message = "";
  TextEditingController namectrl, ticketNumberContrl, passctrl;
  final keyFormS = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    namectrl = new TextEditingController();
    ticketNumberContrl = new TextEditingController();
    passctrl = new TextEditingController();
  }

  bool Signup() {
    return true;
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
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Reserve",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "reserve it now or who knows",
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
                  makeInput2(label: "Full Name"),
                  makeInput3(label: "Number of Tickets"),
                  makeInput(label: "Payment Code", obscureText: true),
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
                      reservetickets();
                      /*context.read<AuthenticationService>().signUp(
                            email: emailctrl.text.trim(),
                            password: passctrl.text.trim(),
                            firstName: namectrl.text.trim(),
                            lastName: ticketNumberContrl.text.trim());*/

                    }
                  },
                  color: Colors.red.withOpacity(0.9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: processing == false
                      ? Text(
                          "Buy",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
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

  Widget makeInput({label, obscureText = false}) {
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
              //  validator: Validator.validatePassword,
              obscureText: obscureText,
              controller: passctrl,
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

  Widget makeInput1({label, obscureText = false}) {
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
              //  validator: Validator.validateEmail,
              obscureText: obscureText,
              // controller: emailctrl,
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

  Widget makeInput2({label, obscureText = false}) {
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
              // validator: Validator.validateFirstName,
              obscureText: obscureText,
              controller: namectrl,
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

  Widget makeInput3({label, obscureText = false}) {
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
              //validator: Validator.validateLastName,
              obscureText: obscureText,
              controller: ticketNumberContrl,
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

  reservetickets() async {
    List<int> ticketList = [];
    String nomClient = namectrl.text;
    int i = 0;
    for (var item in widget.movie.projection[0]["tickets"]) {
      
      if (item["reservee"] == false &&
          i < int.parse(ticketNumberContrl.value.text)) {
        
        ticketList.add(item["id"]);
        i++;
        log(item["id"].toString());
      }
    }
    var body = json.encode({"nomClient": nomClient, "tickets": ticketList});
    log(body);
    final res = await http.post(
        Uri.parse(GlobalV.url+"/payerTickets"),
        body: body,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': "Bearer "+context.read<User>().token

        });
    if (res.statusCode == 200)
      log("status 200");
    else
      log("status is not ok");
  }
}
