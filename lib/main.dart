import 'package:flutter/material.dart';
import 'package:todo/screens/add.dart';
import 'package:todo/screens/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: "/",
      routes: {
        "/": (context) => HomeScreen(),
        "/add": (context) => AddScreen()
      },
    );
  }
}
