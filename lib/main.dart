import 'package:flutter/material.dart';
import 'package:movie_app/screens/authentication/login.dart';
import 'package:movie_app/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import 'models/User.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
  providers: [
    Provider<User>(create: (_) => User()),

  ],
  child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    ),
);


    /*return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );*/
  }
}
