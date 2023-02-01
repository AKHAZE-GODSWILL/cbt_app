
import 'package:cbt_app/main.dart';
import 'package:cbt_app/screens/homePage.dart';
import 'package:flutter/material.dart';


class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key, required this.score}): super(key: key);
  final int score;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: constants.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            
            Text("Congratulations",
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold
              ),
            ),

            SizedBox(height: 50,),

             Text("your score is :",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w400
              ),
             ),

             Text("${widget.score}",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 80,
                  fontWeight: FontWeight.bold
              ),
             ),

             SizedBox(
              height: 50,
             ),

             MaterialButton(
              onPressed: (){
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(
                    builder: (context)=> HomePage()),
                    (route) => false);
              },
              color: Colors.orange,
              textColor: Colors.white,
              elevation: 0,
              child: Text("Repeat Test",),
             )

          ],
        ),
      ),
    );
  }
}