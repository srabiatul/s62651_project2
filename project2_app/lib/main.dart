import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'studentHome.dart';

//import 'home_screen.dart';
//import 'course_listView.dart';
//import 'profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'main',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/signup': (context) => SignUp(),
        '/profile': (context) => StudentHome(),
      },
    );
  }
}
