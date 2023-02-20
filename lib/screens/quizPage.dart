
import 'package:cbt_app/main.dart';
import 'package:cbt_app/models/questionsModel.dart';
import 'package:cbt_app/screens/resultScreen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// this is the first page that runs on the app currently
class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.questionId}): super(key: key);
  final questionId;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  // Creating a page view controller
  // controllers helps you controls one widget through the actions you take on another widget
  PageController _pageController = PageController(initialPage: 0);
  List<QuestionsModel> questionData = [];
  final box= Hive.openBox('quizQuestions');

  final questionsBox = Hive.box('quizQuestions');

  // The question variables 
  bool isPressed = false;
  Color trueAnswer = Colors.green;
  Color wrongAnswer = Colors.red;
  Color btnColor = constants.secondColor;
  int score = 0;

  int pickedIndex = 0;

  @override
  void initState() {

    // questionData.addAll(questionsBox.values.toList().cast<QuestionsModel>());
    

      loadQuestionsFromDatabase().then((value) {
      
      print("The first question timestamp is ${questionData[0].timestamp}");
      
      setState(() {

        if (questionData.length> 1){
        questionData.sort((a,b){
          return a.timestamp!.compareTo(b.timestamp!);
        });
      }
      });
      });


      

    super.initState();
  }

 Future<dynamic> loadQuestionsFromDatabase() async{
    
     questionData.addAll(questionsBox.values
      .toList()
      .where((element) => element.courseId == widget.questionId)
      .cast<QuestionsModel>());
      
      
      
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: constants.mainColor,
      body: Padding(
        padding: EdgeInsets.all(18),
      
        // the page builder is a single widget that renders as many pages needed.
        // To the user, it seems that the page is changing. But its still the same page. Only data is changing
        // example of this kind of feature is your status page on whatsapp, or stories page on instagram
      
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              //The controller is set here
              controller: _pageController,
              onPageChanged: (page){
                setState(() {
                  isPressed = false;
                });
              },

              // disables the scrolling of the page so that we scroll only with the buttons
              physics: NeverScrollableScrollPhysics(),
              // the item count is the number of items to be dispayed.
              // We get this dynamically by getting the length of the list of the questions in our questionsList page
              itemCount: questionData.length,
                
              // the item builder renders the widget that is common to all the pages
              // But only changes the data through the index
                
              itemBuilder: (context, index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // The text widget holding the question number
                    Container(
                      width: double.infinity,
                      child: Text("Question ${index + 1}/ ${questionData.length}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 28
                      ),),
                    ),
                
                    // the divider widget
                    const Divider(
                      color: Colors.white,
                      height: 8,
                      thickness: 1,
                    ),
                
                    // gives a spacing in height between two widgets
                    const SizedBox(
                      height: 20,
                    ),
                
                    // the text that holds the questions
                    Text(questionData[index].question!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28
                      ),
                    ),
                
                    // gives a spacing in height between two widgets
                    const SizedBox(
                      height: 35,
                    ),
                
                
                    // this next part generates the button widgets according to the number of options provided
                    // you can use a for loop and also use mapping out a widget to set this
                
                    for(int i =0; i<questionData[index].options!.length; i++  )
                
                    pickedIndex == i? Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: 70
                      ),
                      margin: EdgeInsets.only(bottom: 18),
                
                      child: MaterialButton(onPressed: isPressed? (){}: (){
                
                       setState(() {
                
                        print(i);
                        isPressed = true;
                        pickedIndex = i;
                        //when the button is pressed, it checks if the option is true
                        // if its true, it sets the color to green
                        if(questionData[index].options![i].entries.toList()[0].value){
                          
                            btnColor = trueAnswer;
                            score += 10; 
                        }
                
                        // it sets the color to red
                        else{
                          
                            btnColor = wrongAnswer;
                        }

                        print(score);
                       });
                      },
                
                        padding: EdgeInsets.only(left: 15, right: 15),
                        shape: StadiumBorder(),
                
                        // the color is stored in a variable so that it can be altered in the future questions[index].options!.entries.toList()[i].value
                        color: isPressed? questionData[index].options![i].entries.toList()[0].value?  trueAnswer:wrongAnswer:constants.secondColor,
                        child: Text(questionData[index].options![i].keys.toList()[0],
                          style: const TextStyle(
                          color: Colors.white,
                          )
                        ),
                      ),
                    )
                    :Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: 70
                      ),
                      margin: EdgeInsets.only(bottom: 18),
                
                      child: MaterialButton(onPressed: isPressed? (){}: (){
                
                       setState(() {
                
                        print(i);
                        isPressed = true;
                        pickedIndex = i;
                        //when the button is pressed, it checks if the option is true
                        // if its true, it sets the color to green
                        if(questionData[index].options![i].entries.toList()[0].value){
                          
                            btnColor = trueAnswer;
                            score += 10;
                        }
                
                        // it sets the color to red
                        else{
                          
                            btnColor = wrongAnswer;
                        }

                        print(score);
                       });
                      },
                
                        padding: EdgeInsets.only(left: 15, right: 15),
                        shape: StadiumBorder(),
                
                        // the color is stored in a variable so that it can be altered in the future questions[index].options!.entries.toList()[i].value
                        color: isPressed? questionData[index].options![i].entries.toList()[0].value?  trueAnswer:constants.secondColor:constants.secondColor,
                        // questions[index].options!.keys.toList()[i]
                        child: Text(questionData[index].options![i].keys.toList()[0],
                          style: const TextStyle(
                          color: Colors.white,
                          )
                        ),
                      ),
                    )
                    ,






                
                    //   Container(
                    //     height: 400,
                    //   // width: MediaQuery.of(context).size.width,
                    //   // constraints: BoxConstraints(
                    //   //   minHeight: 200,
                
                    //   // ),
                    //   child: ListView.builder(
                    //     // physics: ,
                    //     itemCount: questions[index].options!.length,
                    //     itemBuilder: (context, i){
                    //       return pickedIndex == i? Container(
                    //         width: double.infinity,
                    //         constraints: BoxConstraints(
                    //           minHeight: 70
                    //         ),
                    //         margin: EdgeInsets.only(bottom: 18),
                
                    //         child: MaterialButton(onPressed: (){
                            
                    //         print(i);

                    //         pickedIndex = i;

                    //         setState(() {
                
                    //           print(questions[index].options!.entries.toList()[i].value);
                    //           isPressed = true;
                    //           // pickedIndex = index;
                    //           //when the button is pressed, it checks if the option is true
                    //           // if its true, it sets the color to green
                    //           if(questions[index].options!.entries.toList()[i].value){
                                
                    //               btnColor = trueAnswer;
                    //           }
                
                    //           // it sets the color to red
                    //           else{
                                
                    //               btnColor = wrongAnswer;
                    //           }
                    //         });
                    //         },
                
                    //           padding: EdgeInsets.only(left: 15, right: 15),
                    //           shape: StadiumBorder(),
                
                    //           // the color is stored in a variable so that it can be altered in the future questions[index].options!.entries.toList()[i].value
                    //           color: isPressed? questions[index].options!.entries.toList()[i].value?  trueAnswer:wrongAnswer:constants.secondColor,
                    //           child: Text(questions[index].options!.keys.toList()[i],
                    //             style: const TextStyle(
                    //             color: Colors.white,
                    //             )
                    //           ),
                    //         ),
                    //       ): Container(
                    //         width: double.infinity,
                    //         constraints: BoxConstraints(
                    //           minHeight: 70
                    //         ),
                    //         margin: EdgeInsets.only(bottom: 18),
                
                    //         child: MaterialButton(onPressed: (){
                            
                    //         print(i);

                    //         pickedIndex = i;
                    //         setState(() {
                
                    //           print(questions[index].options!.entries.toList()[i].value);
                    //           isPressed = true;
                    //           // pickedIndex = index;
                    //           //when the button is pressed, it checks if the option is true
                    //           // if its true, it sets the color to green
                    //           if(questions[index].options!.entries.toList()[i].value){
                                
                    //               btnColor = trueAnswer;
                    //           }
                
                    //           // it sets the color to red
                    //           else{
                                
                    //               btnColor = wrongAnswer;
                    //           }
                    //         });
                    //         },
                
                    //           padding: EdgeInsets.only(left: 15, right: 15),
                    //           shape: StadiumBorder(),
                
                    //           // the color is stored in a variable so that it can be altered in the future questions[index].options!.entries.toList()[i].value
                    //           color: isPressed? questions[index].options!.entries.toList()[i].value?  trueAnswer:constants.secondColor:constants.secondColor,
                    //           child: Text(questions[index].options!.keys.toList()[i],
                    //             style: const TextStyle(
                    //             color: Colors.white,
                    //             )
                    //           ),
                    //         ),
                    //       );
                    //   }),
                    // ),
                
                    
                    
                    // gives a spacing in height between two widgets
                    const SizedBox(
                      height: 50,
                    ),
                
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: isPressed? index + 1 == questionData.length? (){
                            isPressed = false;
                            
                            Navigator.push(context,
                             MaterialPageRoute(
                              builder: (context)=> ResultScreen(score: score)));
                          }:(){

                            isPressed = false;
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear
                            );
                          }: null,
                          child: Text(
                            index + 1 == questionData.length? "See result"
                            :"Next Question",
                          style: const TextStyle(
                            color: Colors.white
                          ),
                          ),
                          style: ButtonStyle(),
                        ),
                      ],
                    ),
                      
                
                
                  ],
                );
              }),
          ),
        ),
      ),
    );
  }
}