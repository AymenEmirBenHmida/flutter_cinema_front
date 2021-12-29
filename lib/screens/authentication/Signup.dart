import 'package:flutter/material.dart';
import 'package:movie_app/models/User.dart';
import 'package:movie_app/screens/home/home_screen.dart';

import 'package:provider/provider.dart';

import 'package:flutter/services.dart';

import 'login.dart';

class SignupPage extends StatefulWidget {
  // This widget is the root of your application.
  @override
  SignupPage1 createState() => SignupPage1();
}

class SignupPage1 extends State<SignupPage> {
  bool processing = false;
  String message = "";
  TextEditingController firstnamectrl, lastnamectrl, emailctrl, passctrl;
  final keyFormS = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstnamectrl = new TextEditingController();
    lastnamectrl = new TextEditingController();
    passctrl = new TextEditingController();
    emailctrl = new TextEditingController();
  }

  bool Signup() {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // final firebaseUser = context.watch<User>();

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
                    "Signup",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "create an account it's free",
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
                 
                  makeInput2(label: "Name"),
                  
                  makeInput(label: "Password", obscureText: true),
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
                      if(  context
                                    .read<User>().role=="user"){
                                      Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                                    }
                      /*context.read<AuthenticationService>().signUp(
                            email: emailctrl.text.trim(),
                            password: passctrl.text.trim(),
                            firstName: firstnamectrl.text.trim(),
                            lastName: lastnamectrl.text.trim());*/

                    //  AuthenticationService(FirebaseAuth.instance);
                    }
                  },
                  color: Colors.red.withOpacity(0.9),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: processing == false
                      ? Text(
                          "Sign up",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        )
                      : CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                ),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    TextButton(
                      child: Text("Login",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18)),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      },
                    )
                  ])
            ],
          ),
        ),
      ),
    );
  }

  SignUp(){

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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
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
             // validator: Validator.validateEmail,
              obscureText: obscureText,
              controller: emailctrl,
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
             validator:   (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              obscureText: obscureText,
              controller: firstnamectrl,
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
             // validator: Validator.validateLastName,
              obscureText: obscureText,
              controller: lastnamectrl,
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
}
