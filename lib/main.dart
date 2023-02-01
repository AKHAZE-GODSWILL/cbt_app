import 'package:cbt_app/constants.dart';
import 'package:cbt_app/screens/homePage.dart';
import 'package:flutter/material.dart';

void main() {
   
  runApp(const MyApp());
}

Constants constants = Constants();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'CBT APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}


