import 'package:cbt_app/main.dart';
import 'package:cbt_app/models/questionsModel.dart';
import 'package:cbt_app/screens/editQuestion.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ViewAllQuestions extends StatefulWidget{

  const ViewAllQuestions({Key? key, required this.courseId}):super(key: key);
  final String courseId;
  State<ViewAllQuestions> createState()=> _ViewAllQuestions();
}

class _ViewAllQuestions extends State<ViewAllQuestions>{


  bool isLoading = false;

  List<QuestionsModel> questionData = [];
  
  final questionsBox = Hive.box('quizQuestions');

  @override
  void initState() {
    
    // opens the box again to avoid any type of error
    // Hive.openBox("quizQuestions").then((value) {

    //   setState(() {
    //     // I get only the keys and put them in a list
    //   // the reason for doing this is that I'm not only going to be reading the data
    //   // but also updating data. The keys will help me to update these data

    //   questionData.addAll(questionsBox.values
    //   .toList()
    //   .where((element) => element.courseId == widget.courseId)
    //   .cast<QuestionsModel>());

    //   });
    // });

    refreshPage();
    print("Called the refresh page method in the init state");

    super.initState();
  }


  // refreshes the page after any operation has been done
  refreshPage() {

    questionsBox.compact().then((value) {
          print("The refresh page method has been called");
    // cleans the previous list
    questionData.clear();
      // opens the box again to avoid any type of error
  // opens the box again to avoid any type of error
    

   Hive.openBox("quizQuestions").then((value) {

      
      setState(() {

        isLoading = true;
        // I get only the keys and put them in a list
      // the reason for doing this is that I'm not only going to be reading the data
      // but also updating data. The keys will help me to update these data

      loadQuestionsFromDatabase().then((value) {

        if (questionData.length> 1){
        questionData.sort((a,b){
          return  a.timestamp!.compareTo(b.timestamp!);
        });
      }

      });

      

      isLoading = false;
      });

      

  //     QuestionsModel test=  questionsBox.get(20);

  //  print(">>>>>>>>>>>>>>>>>>>>>>>> just to test, the new list is ${test.options}");
    });
    });


   

  }

   Future<dynamic> loadQuestionsFromDatabase() async{
    
     questionData.addAll(questionsBox.values
      .toList()
      .where((element) => element.courseId == widget.courseId)
      .cast<QuestionsModel>());
      
      
      
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      
      backgroundColor: constants.mainColor,
      body: isLoading? const Center(child: CircularProgressIndicator(),) : ListView.builder(
        
        itemCount: questionData.length,
        itemBuilder: (context, index){

          
          QuestionsModel currentQuestion = questionData[index];
          

          return Padding(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: (){

                ////////////////////////
                ///
                ///
                ///

                // creating this object so that the one in the box is not tempered with
                final newObject = QuestionsModel(
                  
                  id: currentQuestion.id,
                  courseId: currentQuestion.courseId,
                  question: currentQuestion.question, 
                  options: currentQuestion.options,
                  timestamp:currentQuestion.timestamp );

                  print(" questions box opened successfully");
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (context)=> EditQuestionPage(
                        currentQuestion: newObject,
                        refreshQuestionsPage: refreshPage,)
                    )
                  );
                  print("Number ${index + 1} question clicked");
                
                



              },
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width*0.9,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8),
                      child: Container(
                        // color: Colors.red,
                        width: MediaQuery.of(context).size.width*0.8,
                        child: Text("${index + 1}.  ${currentQuestion.question}",
                        style: TextStyle(
                          color: Colors.white
                        ),
                        overflow: TextOverflow.ellipsis,
                        ),

                      ),
                    ),

                    InkWell(
                      onTap: () {
                        questionsBox.delete(currentQuestion.id).then((value) {
                          setState(() {
                            questionsBox.compact().then(
                              (value) => refreshPage());
                            
                          });
                        });
                      },

                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 25,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
    );
  }
}