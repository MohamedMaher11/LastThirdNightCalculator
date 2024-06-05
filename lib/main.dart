import 'package:flutter/material.dart';
import 'package:last_third_night/Homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'حساب الثلث الاخير من الليل',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LastThirdCalculator(),
    );
  }
}
