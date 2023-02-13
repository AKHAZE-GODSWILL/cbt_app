
import 'package:cbt_app/main.dart';
import 'package:cbt_app/screens/newTestPage.dart';
import 'package:cbt_app/screens/quizPage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// this is the first page that runs on the app currently
class HomePage extends StatefulWidget {
  const HomePage({Key? key}): super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Creating a page view controller
  // controllers helps you controls one widget through the actions you take on another widget
  // PageController _pageController = PageController(initialPage: 0);
  List courses = [];
  final courseBox = Hive.box('courseCodes');

  @override
  void initState() {
    
    
    courses.addAll(courseBox.values.toList());
    super.initState();
  }


  // this method is passed into the newTest page and is called from that page
  // anytime a new question is added, the UI of this page refreshes
  // this way, users don't need to restart the app to gain access to newly written data
  updateQuestionList(){

    // clears the previous list and makes a request for the updated list
    courses.clear();

    setState(() {

      Hive.openBox('quizQuestions');
      courses.addAll(courseBox.values.toList());
    });

    print("The update question List function called");
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: constants.mainColor,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          createNewTestDialog(context: context);
        },
        backgroundColor: Colors.orange,
        child: Icon(Icons.add,

        ),
      ),

      // I need to make app constantly listen to changes in the database and update
      // once the app changes

      body: ListView.builder(

        itemCount: courses.length,
        itemBuilder: (context, index){
          return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 80,),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width*0.7,
              height: 200,
              decoration: BoxDecoration(
              // color: Colors.orange,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.orange,
                // width: 1.5
              )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  SizedBox(height: 40,),
                  Text(courses[index].courseCode,
                  style:TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 28
                    ),),

                    SizedBox(height: 50,),

                    Container(
                      margin: EdgeInsets.only(left: 50),
                      height: 30,
                      width: 200,
                      // color: Colors.green,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                        height: 30,
                        width: MediaQuery.of(context).size.width*0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors. orange
                        ),
                        child: InkWell(
                          onTap: (){

                            // I have to open the box before pushing to the current page,
                            // else, different kinds of error are encountered in different levels
                            Hive.openBox('quizQuestions')
                            .then((value) => Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=> QuizPage(
                                  questionId: courses[index].courseId,) 
                              )
                            ));

                            print("box is opened");
                            
                          },
                          child: Center(
                            child: Text("Start Test",
                              style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 18
                                              ),),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),

                      Icon(Icons.add,
                        color: Colors.white,
                      )
                        ],
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      );
        })
    );
  }

  createNewTestDialog({context}){
    TextEditingController _newTestController = TextEditingController();

    return showDialog(
      barrierColor: Colors.black.withOpacity(0.9),
      context: context,
      builder: (context){

        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              
            height: MediaQuery.of(context).size.height,
            width:  MediaQuery.of(context).size.width,
            child: Column(
              children: [

                Container(
                  child: Text("Add New Test",
                    style:TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    fontSize: 20
                                    ),),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height* 0.05
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text("Test Title",
                      style:TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 15
                                      ),),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height* 0.02
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                    color: Colors.white.withOpacity(0.1),
                    
                    child:  Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: _newTestController,
                        onChanged: (value) => {
                          setState((){
                            print("Changed");
                          })
                        },
                        style: const TextStyle(
                          color: Colors.white
                        ),
                        decoration: const InputDecoration(
                          hintText: "Please enter Test title",
                          hintStyle: TextStyle(
                            color: Colors.white54
                          ),
                          focusedBorder: InputBorder.none
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height* 0.02
                ),

                _newTestController.text.isEmpty? SizedBox():
                Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width*0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors. orange
                              ),
                              child: GestureDetector(
                                onTap: (){

                                  print("The OK button pushed");
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewTestPage(courseName: _newTestController.text.trim(), refreshHomePage: updateQuestionList,)));
                                },
                                child: Center(
                                  child: Text("OK",
                                    style:TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    decoration: TextDecoration.none,
                                    fontSize: 18
                                                    ),),
                                ),
                              ),
                            ),

                
              ],
            ),
            );
          }
        );
      }
    );
  }
}