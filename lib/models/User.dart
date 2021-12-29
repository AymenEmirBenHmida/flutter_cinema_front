import 'dart:convert';
import 'dart:developer';

import 'package:jwt_decoder/jwt_decoder.dart';

import 'globalV.dart';
import 'package:http/http.dart' as http;

class User {
  dynamic token;
  String role;
  User({this.token, this.role});

  void setToken(dynamic token) {
    this.token = token;
  }

  setRoles(String roles) {
    this.role = roles;
  }

  getRoles() {
    return this.role;
  }

  getToken() {
    return this.token;
  }

  Login(String username, String password) async {
    http.Response response = await http.post(
      Uri.parse(GlobalV.urlLogin),
      body: json.encode({"username": username, "password": password}),
    );
    if (response.statusCode == 200)
      log("status 200");
    else
      log("status is not ok");

    this.token = response.headers["authorization"];

    log(this.token.toString());
    Map<String, dynamic> decodedToken = JwtDecoder.decode(this.token);
    if (decodedToken["roles"].length > 1) {
      this.role = "admin";
    } else
      this.role = "user";

    return role;
  }

  Signup(String username, String password) async {
    http.Response response = await http.post(
      Uri.parse(GlobalV.urlSignup),
      body: json.encode({"username": username, "password": password}),
    );
    if (response.statusCode == 200)
      log("status 200");
    else
      log("status is not ok");

    this.token = response.headers["authorization"];

    log(this.token.toString());
    Map<String, dynamic> decodedToken = JwtDecoder.decode(this.token);
    if (decodedToken["roles"].length > 1) {
      this.role = "admin";
    } else
      this.role = "user";

    return role;
  }
}
