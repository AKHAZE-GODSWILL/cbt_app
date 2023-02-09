import 'package:cbt_app/constants.dart';
import 'package:cbt_app/models/courseModel.dart';
import 'package:cbt_app/models/questionsModel.dart';
import 'package:cbt_app/myWidgets.dart';
import 'package:cbt_app/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async{
   
  WidgetsFlutterBinding.ensureInitialized();

  ///////// Anything you see about hive is all about local database management 
  await Hive.initFlutter();

  ////////// This place is for me to register the various adapters
  
  Hive.registerAdapter(QuestionsModelAdapter());
  Hive.registerAdapter(CourseModelAdapter());
   

  ///////// Opening each of the hive Collections or boxes in this case
  await Hive.openBox('courseCodes');
  await Hive.openBox('quizQuestions');

  runApp(const MyApp());
}

Constants constants = Constants();
MyWidgets myWidgets = MyWidgets();

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


