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

enum MenuValues{
    editQuestion,
    delete
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
      body: isLoading? const Center(child: CircularProgressIndicator(),) : questionData.isEmpty? Center(
        child: Text("Your Questions List is empty",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.orange,
          fontSize: 25,
        ),)
      ): ListView.builder(
        
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
                

                  print(" questions box opened successfully");


                  // Navigator.push(
                  //   context, 
                  //   MaterialPageRoute(
                  //     builder: (context)=> EditQuestionPage(
                  //       currentQuestion: newObject,
                  //       refreshQuestionsPage: refreshPage,)
                  //   )
                  // );
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
                        width: MediaQuery.of(context).size.width*0.75,
                        child: Text("${index + 1}.  ${currentQuestion.question}",
                        style: TextStyle(
                          color: Colors.white
                        ),
                        overflow: TextOverflow.ellipsis,
                        ),

                      ),
                    ),

                    InkWell(

                      // onTap: () {

                      //   questionsBox.delete(currentQuestion.id).then((value) {
                      //     setState(() {
                      //       questionsBox.compact().then(
                      //         (value) => refreshPage());
                            
                      //     });
                      //   });
                      // },

                      child: PopupMenuButton<MenuValues>(
                        icon: Icon(Icons.more_vert, color: Colors.white,),
                        color: Colors.black.withOpacity(0.5),
                        itemBuilder: (BuildContext context)=>[
                          const PopupMenuItem(
                            child: Text("Edit Question", 
                              style: TextStyle(color: Colors.white),
                            ),
                            value: MenuValues.editQuestion,
                          ),

                          const PopupMenuItem(
                            child: Text("Delete", 
                              style: TextStyle(color: Colors.white),
                            ),
                            value: MenuValues.delete,
                          )
                        ],

                        onSelected: (value){

                          if(value == MenuValues.editQuestion){

                            final newObject = QuestionsModel(
                            
                            id: currentQuestion.id,
                            courseId: currentQuestion.courseId,
                            question: currentQuestion.question, 
                            options: currentQuestion.options,
                            timestamp:currentQuestion.timestamp );

                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context)=> EditQuestionPage(
                                  currentQuestion: newObject,
                                  refreshQuestionsPage: refreshPage,)
                              )
                            );
                           print("Number ${index + 1} question clicked");

                          }

                          // if the delete was selected from the pop up menu
                          else if(value == MenuValues.delete){

                            deleteQuestionDialog(context: context, courseData: currentQuestion);
                              
                          }

                        },
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


   // This runs when the edit button is clicked
  deleteQuestionDialog({required context, required courseData}){
    

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
                        height: 350,
                        width: MediaQuery.of(context).size.width*0.75,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: constants.mainColor
                        ),
                        child: GestureDetector(

                          onTap: (){
                            
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(left:10, right: 10),
                                child: Text("PlEASE CONFIRM ACTION",
                                  style:TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18
                                                  ),),
                              ),


                            SizedBox(
                              height: 10,
                            ),

                          Padding(
                            padding: const EdgeInsets.only(left:10, right: 10),
                            child: Text("Are sure you want to delete this question?",
                              style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 17
                                              ),),
                          ),

                          SizedBox(
                              height: 30,
                            ),

                          GestureDetector(
                            onTap: (){
                               Navigator.pop(context);
                            },
                            child: Container(
                                                  height: 50,
                                                  width: MediaQuery.of(context).size.width*0.55,
                                                  decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.orange
                            )
                                                  ),
                                                  child: Center(
                            child: Text("No",
                              style:TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 18
                                              ),),
                                                  ),
                                                ),
                          ),

                           SizedBox(
                              height: 20,
                            ),

                          GestureDetector(
                            onTap: (){
                               setState((){
                                isLoading = true;

                                questionsBox.delete(courseData.id).then((value) {
                                  setState(() {
                                    questionsBox.compact().then(

                                      (value) { 
                                        refreshPage();
                                        Navigator.pop(context);
                                      }
                                      
                                    );
                                    
                                  });
                                });
                               });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width*0.55,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red
                              ),

                              child: Center(
                                child: isLoading? CircularProgressIndicator(color: Colors.white,): Text("Yes",
                                  style:TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 18
                                  ),),
                              ),
                            ),
                          ),
                            
                      ],
                          )
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