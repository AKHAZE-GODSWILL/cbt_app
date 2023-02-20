///// What I am passing into this page
/// I need the object of the question
/// I also need the key of the question
/// I need to refresh the previous page after the save action has been carried out
/// I need to loop through the object to find the initial answer
/// Selected options is automatically true after the group index has been found
/// I need to update the page and then pop this page
/// 
/// 
/// 
/// bug alerttttttttttttt the data is changing even when I have not yet updated it

import 'package:cbt_app/main.dart';
import 'package:cbt_app/models/questionsModel.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';


///////////// Check first if there is a question
/// check if there are options
/// check if there is an answer
/// 
class EditQuestionPage extends StatefulWidget{

const EditQuestionPage({Key? key,


 required this.currentQuestion,
 required this.refreshQuestionsPage}):super(key:key);

// final String questionId;
final dynamic currentQuestion;
final Function refreshQuestionsPage;
@override 
State<EditQuestionPage> createState()=> _EditQuestionPage();

}


/// I also have to make sure that question and one answer is chosen as true before submission is made

/// Try and make sure that the create new and the edit old quiz use the same page
/// where there is room to send existing questions into the page and if it is null, another system should be used

class _EditQuestionPage extends State<EditQuestionPage>{

  bool isLoading = false;

  // the unique id for this particular test
  // String courseUniqueId = "";

  bool answerSelected = false;

  // the controller for the question text field
  TextEditingController _newTestController = TextEditingController();

  int optionsNumber = 1;

  // group value is set to -1 so that no answer is set to true initially
  // the user must be the one to select an answer
  int groupValue = -1;

  // initializes a fresh object to store my question and  options
  // and force the data into an exact structure
  QuestionsModel questionDetails = QuestionsModel(id: "",courseId: "",question: "", options: [], timestamp: DateTime.now());

  // this list will hold all the text editing controller list
  List<TextEditingController> controllerList = [];

  String editedQuestion = "";

  String editedQuestionId = "";

  String editedQuestionCourseId = "";

  List<Map<String, bool>> editedOptions = [];

 late DateTime editedQuestionTimestamp ;

  final questionsBox = Hive.box('quizQuestions');



  @override
  void initState() {

    
    // the hive object it a live object and any changes made to the objects,
    // reflects in the box. Creating a fresh new object is one of the best way
    // to avoid the error of data changing without you needing it to
    // questionDetails = QuestionsModel(
    //   id: widget.currentQuestion.id, 
    //   question: widget.currentQuestion.question, 
    //   options: widget.currentQuestion.options);

    editedQuestionId = widget.currentQuestion.id;
    editedQuestionCourseId = widget.currentQuestion.courseId;
    editedQuestion = widget.currentQuestion.question;
    editedOptions.addAll(widget.currentQuestion.options);
    editedQuestionTimestamp = widget.currentQuestion.timestamp;

    print("The current question timestamp is ${editedQuestionTimestamp}");

    // print("The edited question key is ${widget.questionKey}");

    print("The edited question is ${editedQuestion}");
    print("The edited option is ${editedOptions}");

    setState(() {

      

      _newTestController.text = editedQuestion;

      // replaces the initial question with the sent in object
      

      optionsNumber = editedOptions.length;
  

    });

    // dynamically generates a TextEditing Controller for each Text Widget
    controllerList = List.generate(optionsNumber, (x) => TextEditingController());

    for(int x = 0; x< editedOptions.length; x++){

          if(editedOptions[x].entries.toList()[0].value){
            groupValue = x;
            answerSelected = true;
          }

          print(editedOptions[x].entries.toList()[0]);
          /////////////// automatically setting the options     
        controllerList[x].text = editedOptions[x].keys.toList()[0];

      }

    print("group value after detecting the answer is ${groupValue}");

    // ensures there is one text editing controller for the app to work with
    // the first time the app is opened
    // controllerList.add(TextEditingController());

    

    super.initState();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose

  //   print("The questions box closed successfully");

  //   questionsBox.close();
  //   super.dispose();
  // }

  @override 
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor: constants.mainColor,
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: MediaQuery.of(context).size.height* 0.1),

            Container(
              color: Colors.white.withOpacity(0.1),
              width: MediaQuery.of(context).size.width,
              constraints: BoxConstraints(
                minHeight:MediaQuery.of(context).size.height*0.1,
                maxHeight: MediaQuery.of(context).size.height*0.2,
              ),
              child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: TextField(
                          controller: _newTestController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          expands: true,
                          minLines: null,
                          onChanged: (value) => {
                            setState((){
                              print("Changed");

                              editedQuestion = value;

                            })
                          },
                          style: const TextStyle(
                            color: Colors.white
                          ),
                          decoration: const InputDecoration(
                            hintText: "Enter Quiz Question Here",
                            hintStyle: TextStyle(
                              color: Colors.white38
                            ),
                            focusedBorder: InputBorder.none
                          ),
                        ),
                      ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height* 0.05),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("Add options",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
            ),

            InkWell(
              onTap: (){

                
                setState(() {
                  
                  //Checks if the current Textfield is filled before adding a new one
                  // The best way is to use the controller . This way still works

                  if(optionsNumber> editedOptions.length){
                    myWidgets.showToast(message: "Fill the current text first");
                  }

                  // Adds a new text form field to the list view builder
                  else{
                    

                           ++optionsNumber;

                          // removes focus from the current text widget

                          FocusScopeNode currentFocus = FocusScope.of(context);
                            if(!currentFocus.hasPrimaryFocus){
                              currentFocus.unfocus();
                            }

                          // dynamically generates a TextEditing Controller for each Text Widget
                          controllerList = List.generate(optionsNumber, (i) => TextEditingController());

                          // sets the text for the controllers for all the text form field
                          // so that the filled text fields can be indicated to the user
                          // failure to do this gets the text field wiped off even the data is still there
                          for(int x = 0; x< editedOptions.length; x++){

                            controllerList[x].text = editedOptions[x].keys.toList()[0];
                          }
                  }
                });


              },
              child: Padding(
                padding: const EdgeInsets.only(left:10, right: 20),
                child: Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle
                  ),
                  child: Center(child: Icon(Icons.add)),
                ),
              ),
            )
              ],
            ),

            // SizedBox(height: MediaQuery.of(context).size.height* 0.05),

              Container(
                        // color: Colors.red,
                        height: 400,
                      // width: MediaQuery.of(context).size.width,
                      // constraints: BoxConstraints(
                      //   minHeight: 200,
                
                      // ),
                      child: ListView.builder(

                        
                        itemCount: optionsNumber,
                        itemBuilder: (context, i){
                        
                        
                          print("Options Number is ${optionsNumber}");

                        return  Row(
                          children: [
                            Radio(
                                  value: i, 
                                  groupValue: groupValue, 
                                  toggleable: true,
                                  onChanged: (value){

                                    
                                    
                                    setState(() {
                                      
                                      if(editedOptions.asMap().containsKey(i)){

                                        print(">>>>>>>>>>>> Option at index ${i} has been set");
                                        groupValue = i;

                                        // So what is happening here is that I am getting the data from the options object I have saved
                                        // so can i can manipulate the question model anytime I want

                                        // This piece of code sets all the elements in the option to false apart from the one that you have selected
                                        // only the one that is currently selected is set as true

                                        // The reason why I use questionDetails.options[i].keys.toList()[0] is because its a list with maps
                                        // and the each map contains only one item so I use that method to access the keys

                                        print("The current group value is ${groupValue}");
                                        print("And the current index is ${i}");

                                        for(int x = 0; x<editedOptions.length; x++ ){

                                          // This place gets the options currently stored in the object
                                          // modifies all the data based on the radio button that was clicked and update the data
                                          // into the same spot
                                          editedOptions[x] = groupValue ==x? {editedOptions[x].keys.toList()[0] : true} 
                                            :{editedOptions[x].keys.toList()[0] : false};
                                        }

                                        // handles the check to make sure that an answer is selected
                                        answerSelected = true;
                                      }

                                      else{
                                        

                                        myWidgets.showToast(message: "Fill the Text field first before choosing an answer");
                                      }
                                    });

                                  }
                                ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10, bottom:10),
                              child: Container(
                                  color: Colors.white.withOpacity(0.1),
                                  width: MediaQuery.of(context).size.width*0.85,
                                  height: MediaQuery.of(context).size.height*0.055,
                                  child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: TextFormField(

                                    controller: controllerList[i],
                                    // initialValue: "hey",
                                    // keyboardType: TextInputType.multiline,
                                    // maxLines: null,
                                    // expands: true,
                                    // minLines: null,
                                    onChanged: (value)  {

                                        // if whatever was entered was cleaned after wards ,
                                        // that data is deleted from the options
                                        // and the list view builder is reduced by one
                                        
                                        // print("Before the refresh page was called");

                                        // // Hive.box('quizQuestions').close();
                                        // // widget.refreshQuestionsPage();
                                        // print("After the refresh page was called");
                                        
                                        
                                        if(value == ""){

                                          // This place just removes focus from the current
                                          //text widget. This makes the underground operation cleaner
                                          FocusScopeNode currentFocus = FocusScope.of(context);

                                          if(!currentFocus.hasPrimaryFocus){
                                            currentFocus.unfocus();
                                          }

                                          setState(() {

                                            if(optionsNumber > 1){

                                              print(" One of the options has been removed");
                                              --optionsNumber;

                                              // removes the controller at tha particular index
                                              controllerList.removeAt(i);
                                              
                                            }
                                            
                                          });

                                          // Remove the controller and the option at that index where the question was wiped
                                            editedOptions.removeAt(i);
                                            // controllerList.removeAt(i);
                                            
                                            // if the option that was removed is currently holding the answer
                                            // unclick every other radio button
                                            if(groupValue == i){
                                              groupValue = -1;
                                              
                                            } 

                                            // changes the answer selected back to false if the current question is
                                            // being wipped away
                                            answerSelected = false;
                                        }

                                        else{
                                          
                                        // checks if the position on this index is filled
                                        
                                        // if it is filled, it replaces what ever value that was there before
                                        if(editedOptions.asMap().containsKey(i)){

                                          editedOptions[i] = {value: groupValue ==i? true: false};
                                        }

                                        // if it is empty, insert to that position
                                        else{

                                        editedOptions.insert(i, {value: groupValue ==i? true: false});
                                        }
                                          
                                        }

                                        // questionsBox.put(widget.questionKey, widget.currentQuestion);
                                    },
                                    style: const TextStyle(
                                      color: Colors.white
                                    ),
                                    decoration: const InputDecoration(
                                      
                                      hintText: "Enter Option Here",
                                      hintStyle: TextStyle(
                                        color: Colors.white38
                                      ),
                                      
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height* 0.03),

                    Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width*0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors. orange
                          ),
                          child: InkWell(
                            onTap: (){

                              // the first check to ensure that a question is filled in
                              if(_newTestController.text.isNotEmpty){

                                  // the second check to ensure that there is atleast on option
                                  if(editedOptions.isNotEmpty){
                                    

                                    // checks if an answer is selected
                                    if(answerSelected){

                                      setState((){
                                        isLoading = true;
                                      });
                                      // creates a hivebox instance to write a course and question into local database
                                      
                                      // final questionsBox = Hive.box('quizQuestions');

                                        // add question to the local storage database
                                        

                                          questionDetails.id = editedQuestionId;
                                          questionDetails.courseId = editedQuestionCourseId;
                                          questionDetails.question = editedQuestion;
                                          questionDetails.timestamp = editedQuestionTimestamp;
                                          questionDetails.options!.addAll(editedOptions);


                                          /////////////////////// this place is supposed to handle updating of questions
                                          ///
                                          print("The new question details is ${questionDetails.question}");
                                          print("The new question options is ${questionDetails.options}");

                                          // questionsBox.deleteAt(widget.questionKey).then((value) {

                                             questionsBox.put(editedQuestionId, questionDetails).then(
                                            (value)  {

                                              

                                              setState((){
                                                isLoading = false;
                                              });


                                              Hive.openBox("quizQuestions").then((value) {

                                                setState(() {
                                                  // I get only the keys and put them in a list
                                                // the reason for doing this is that I'm not only going to be reading the data
                                                // but also updating data. The keys will help me to update these data

                                                final Map questionMap = questionsBox.toMap();
                                                

                                                questionMap.forEach((key, value){

                                                     print('>>>>>>>>>>>>>>>>>>>>>Printing all the questions now');

                                                     print(value.question );

                                                });

                                                
                                                });
                                              });

                                              // print("Edited the question successfully");

                                              widget.refreshQuestionsPage();
                                              // print("refreshed the previous page successfully");
                          
                                              myWidgets.showToast(message: "Question added successfully");

                                              isLoading== false? Navigator.pop(context): (){};

                                            }
                                          );

                                          // });
                                         
                                        
                                    

                                      
                                    }
                                    

                                    // runs if no answer is currently selected
                                    else{
                                      myWidgets.showToast(message: "Select on option as an answer");
                                    }

                                  }

                                  // runs if there is no option selected
                                  else{
                                    myWidgets.showToast(message: "Please insert at least one option");
                                  }
                              }
                              
                              // runs if there is no question inputed
                              else{
                                myWidgets.showToast(message: "Please Enter a question ");
                              }
                            },
                            child:  Center(
                              child: isLoading? CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                strokeWidth: 2,
                              ): const Text( "DONE",
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
      ),
    );
  }
}