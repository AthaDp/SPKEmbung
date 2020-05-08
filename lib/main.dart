import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'SPK Embung',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primaryColor: Color(0xFF21BFBD),
        ),
        home: new HomePage());
    //home: new RootPage(auth: new Auth()));
  }
}
