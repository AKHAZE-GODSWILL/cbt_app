
import 'package:cbt_app/main.dart';
import 'package:cbt_app/models/questionsModel.dart';
import 'package:cbt_app/screens/newTestPage.dart';
import 'package:cbt_app/screens/quizPage.dart';
import 'package:cbt_app/screens/viewAllQuestions.dart';
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
    
    
    // courses.addAll(courseBox.values.toList());
    updateQuestionList();

    print("The update question list called in the init state");
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

      if (courses.length> 1){
        courses.sort((a,b){
          return a.timestamp.compareTo(b.timestamp);
        });
      }
      
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

      body: courses.isEmpty? Center(
        child: Text("Your Quiz List is Empty,\nClick the Add button\nbelow to add new Quiz",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 25,
        ),)
      ):ListView.builder(

        itemCount: courses.length,
        itemBuilder: (context, index){
          return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40,),
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
                      height: 50,
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

//////////////////////////////////////////////////////////////////////////////
///this is where I need to change
                      
                      
                      InkWell(
                        onTap: (){
                          print("The Edit button tapped");

                          // courseCodes
                          Hive.openBox('courseCodes').then((value) {
                            final Map courseMap = courseBox.toMap();
                            dynamic courseKey;
                            

                            // since id is unique, I'm sure this is going to run only once
                            courseMap.forEach((key, value){
                              if(value.courseId == courses[index].courseId)
                              courseKey = key;

                              print(courseKey);
                            });


                            editTestDialog(
                              context: context,
                              courseData: courses[index],
                              // courseNumber: courseKey, 
                              refreshHomePage: updateQuestionList
                           );
                          });
                          
                          //  refreshHomePage: updateQuestionList() 
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          // color: Colors.red,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              customEditButton(),
                              customEditButton(),
                              customEditButton()
                            ],
                          ),
                        ),
                      )

                      ],
                      ),
                    )
                ],
              ),
            ),
          ),

          SizedBox(height: 40,),
        ],
      );
        })
    );
}

  customEditButton(){
    return Container(
      height: 4,
      width: 4,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle
      ),
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
                GestureDetector(
                  onTap: (){

                                  print("The OK button pushed");
                                  Navigator.pop(context);

                                  Hive.openBox('quizQuestions').then((value) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NewTestPage(
                                    courseName: _newTestController.text.trim(),
                                    existingCourseId: "",
                                    refreshHomePage: updateQuestionList,)));
                                  });
                                  
                                },
                  child: Container(
                                height: 30,
                                width: MediaQuery.of(context).size.width*0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors. orange
                                ),
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

  // This runs when the edit button is clicked
  editTestDialog({context, courseData, required Function refreshHomePage}){
    

    return showDialog(
      barrierColor: Colors.black.withOpacity(0.9),
      context: context,
      builder: (context){

        bool isLoading = false;

        // stateful builder is used so that the dialog can change its state
        // if you don't use it, you cant change state
        return StatefulBuilder(
          builder: (context, setState) {

            return Container(
              
            height: MediaQuery.of(context).size.height,
            width:  MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            

              // the add new question button
               Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width*0.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors. orange
                        ),
                        child: GestureDetector(

                          onTap: (){

                            
                            Hive.openBox('quizQuestions').then((value) {

                              Navigator.pop(context);

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewTestPage(
                              courseName: courseData.courseCode,
                              existingCourseId: courseData.courseId,
                              refreshHomePage: updateQuestionList,)));

                            });
                            
                            
                          },
                          child: Center(
                            child: Text("Add New Question",
                              style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 18
                                              ),),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height* 0.05
                    ),

                      // the All questions button, takes user to the all questions page
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors. orange
                        ),
                        child: GestureDetector(
                          onTap: (){

                            Navigator.pop(context);
                            Hive.openBox("quizQuestions").then((value) {
                              
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=> ViewAllQuestions(courseId: courseData.courseId, )
                              )
                            );
                            });
                            
                            
                            
                          },
                          child: Center(
                            child: Text("All Questions",
                              style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 18
                                              ),),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height* 0.05
                      ),

                      // the delete button, performs the delete operations

                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width*0.55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors. orange
                        ),
                        child: GestureDetector(
                          onTap: (){

                            // sets loading to true so the circular progress indicator can show loading
                            // when button is pressed

                            setState((){
                              isLoading = true;
                            });

                            // Hive box is opened again to avoid any errors

                            Hive.openBox('quizQuestions').then((value) {

                            final questionsBox = Hive.box('quizQuestions');

                            // loads the full questions into the question Map variable so that sorting 
                            // can take place

                            final Map questionMap = questionsBox.toMap();
                            dynamic desiredKey;


                            int i = 1;

                            // this code is going to loop through the entire questions and performs
                            // the delete action anywhere the if statement condition is met

                            questionMap.forEach((key, value){

                                  if (value.courseId == courseData.courseId)
                                      desiredKey = key;

                                     desiredKey !=null?  questionsBox.delete(value.id) : print('Still loading');

                                     print("Deleted operation ran successfully $i times");

                                     i++;
                            });

                              // immediately all the the questions are deleted, the course is deleted too
                              courseBox.delete(courseData.courseId);
                              setState((){
                              
                              // the refresh home page function is called to update the Ui and show users
                              // the available questions left

                              questionsBox.compact().then((value) => refreshHomePage());
                              isLoading = false;

                              Navigator.pop(context);
                              myWidgets.showToast(message: "Course deleted successfully");
                            });
                              // questionsBox.delete(desiredKey);
                            });
                            
                          },
                          child: Center(
                            child: isLoading? Center(child: CircularProgressIndicator(),):Text("Delete",
                              style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
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