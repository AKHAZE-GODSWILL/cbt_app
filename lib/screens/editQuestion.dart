

// import 'package:cbt_app/main.dart';
// import 'package:cbt_app/models/courseModel.dart';
// import 'package:cbt_app/models/questionsModel.dart';
// import 'package:hive/hive.dart';
// import 'package:uuid/uuid.dart';
// import 'package:flutter/material.dart';


// ///////////// Check first if there is a question
// /// check if there are options
// /// check if there is an answer
// /// 
// class EditQuestionPage extends StatefulWidget{

// const EditQuestionPage({Key? key, required this.courseName}):super(key:key);
// final String courseName;
// @override 
// State<EditQuestionPage> createState()=> _EditQuestionPage();

// }


// /// I also have to make sure that question and one answer is chosen as true before submission is made

// /// Try and make sure that the create new and the edit old quiz use the same page
// /// where there is room to send existing questions into the page and if it is null, another system should be used

// class _EditQuestionPage extends State<EditQuestionPage>{


//   // the unique id for this particular test
//   String courseUniqueId = "";

//   bool answerSelected = false;

//   // the controller for the question text field
//   TextEditingController _newTestController = TextEditingController();

//   int optionsNumber = 1;

//   // group value is set to -1 so that no answer is set to true initially
//   // the user must be the one to select an answer
//   int groupValue = -1;

//   // initializes a fresh object to store my question and  options
//   // and force the data into an exact structure
//   QuestionsModel questionDetails = QuestionsModel(id: "",question: "", options: []);
//   CourseModel courseDetails = CourseModel(courseId: "", courseCode: "");

//   // this list will hold all the text editing controller list
//   List<TextEditingController> controllerList = [];



//   @override
//   void initState() {

//     // ensures there is one text editing controller for the app to work with
//     // the first time the app is opened
//     controllerList.add(TextEditingController());

//     // creates a unique Id to be saved for this question
//     courseUniqueId = Uuid().v4();

//     // sets the id generated into the question and the course object
//     questionDetails.id = courseUniqueId;
//     courseDetails.courseId = courseUniqueId;

//     // sets the name of the course object
//     courseDetails.courseCode = widget.courseName;

//     super.initState();
//   }

//   @override 
//   Widget build(BuildContext context){

//     return Scaffold(

//       backgroundColor: constants.mainColor,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [

//             SizedBox(height: MediaQuery.of(context).size.height* 0.1),

//             Container(
//               color: Colors.white.withOpacity(0.1),
//               width: MediaQuery.of(context).size.width,
//               constraints: BoxConstraints(
//                 minHeight:MediaQuery.of(context).size.height*0.1,
//                 maxHeight: MediaQuery.of(context).size.height*0.2,
//               ),
//               child: Padding(
//                         padding: EdgeInsets.only(left: 10, right: 10),
//                         child: TextField(
//                           controller: _newTestController,
//                           keyboardType: TextInputType.multiline,
//                           maxLines: null,
//                           expands: true,
//                           minLines: null,
//                           onChanged: (value) => {
//                             setState((){
//                               print("Changed");

//                               questionDetails.question = value;

//                             })
//                           },
//                           style: const TextStyle(
//                             color: Colors.white
//                           ),
//                           decoration: const InputDecoration(
//                             hintText: "Enter Quiz Question Here",
//                             hintStyle: TextStyle(
//                               color: Colors.white38
//                             ),
//                             focusedBorder: InputBorder.none
//                           ),
//                         ),
//                       ),
//             ),

//             SizedBox(height: MediaQuery.of(context).size.height* 0.05),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text("Add options",
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.w500
//             ),
//             ),

//             InkWell(
//               onTap: (){

                
//                 setState(() {
                  
//                   //Checks if the current Textfield is filled before adding a new one
//                   // The best way is to use the controller . This way still works

//                   if(optionsNumber> questionDetails.options!.length){
//                     myWidgets.showToast(message: "Fill the current text first");
//                   }

//                   // Adds a new text form field to the list view builder
//                   else{
                    

//                            ++optionsNumber;

//                           // removes focus from the current text widget

//                           FocusScopeNode currentFocus = FocusScope.of(context);
//                             if(!currentFocus.hasPrimaryFocus){
//                               currentFocus.unfocus();
//                             }

//                           // dynamically generates a TextEditing Controller for each Text Widget
//                           controllerList = List.generate(optionsNumber, (i) => TextEditingController());

//                           // sets the text for the controllers for all the text form field
//                           // so that the filled text fields can be indicated to the user
//                           // failure to do this gets the text field wiped off even the data is still there
//                           for(int x = 0; x< questionDetails.options!.length; x++){
//                             controllerList[x].text = questionDetails.options![x].keys.toList()[0];
//                           }
//                   }
//                 });


//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left:10, right: 20),
//                 child: Container(
//                   height: 28,
//                   width: 28,
//                   decoration: BoxDecoration(
//                     color: Colors.orange,
//                     shape: BoxShape.circle
//                   ),
//                   child: Center(child: Icon(Icons.add)),
//                 ),
//               ),
//             )
//               ],
//             ),

//             // SizedBox(height: MediaQuery.of(context).size.height* 0.05),

//               Container(
//                         // color: Colors.red,
//                         height: 400,
//                       // width: MediaQuery.of(context).size.width,
//                       // constraints: BoxConstraints(
//                       //   minHeight: 200,
                
//                       // ),
//                       child: ListView.builder(

                  
//                         itemCount: optionsNumber,
//                         itemBuilder: (context, i){
                        
                          

//                         return  Row(
//                           children: [
//                             Radio(
//                                   value: i, 
//                                   groupValue: groupValue, 
//                                   toggleable: true,
//                                   onChanged: (value){
                                    
//                                     setState(() {
                                      
//                                       if(questionDetails.options!.asMap().containsKey(i)){

//                                         print(">>>>>>>>>>>> Option at index ${i} has been set");
//                                         groupValue = i;

//                                         // So what is happening here is that I am getting the data from the options object I have saved
//                                         // so can i can manipulate the question model anytime I want

//                                         // This piece of code sets all the elements in the option to false apart from the one that you have selected
//                                         // only the one that is currently selected is set as true

//                                         // The reason why I use questionDetails.options[i].keys.toList()[0] is because its a list with maps
//                                         // and the each map contains only one item so I use that method to access the keys

//                                         print("The current group value is ${groupValue}");
//                                         print("And the current index is ${i}");

//                                         for(int x = 0; x<questionDetails.options!.length; x++ ){

//                                           // This place gets the options currently stored in the object
//                                           // modifies all the data based on the radio button that was clicked and update the data
//                                           // into the same spot
//                                           questionDetails.options![x] = groupValue ==x? {questionDetails.options![x].keys.toList()[0] : true} 
//                                             :{questionDetails.options![x].keys.toList()[0] : false};
//                                         }

//                                         // handles the check to make sure that an answer is selected
//                                         answerSelected = true;
//                                       }

//                                       else{
                                        

//                                         myWidgets.showToast(message: "Fill the Text field first before choosing an answer");
//                                       }
//                                     });

//                                   }
//                                 ),

//                             Padding(
//                               padding: const EdgeInsets.only(top: 10, bottom:10),
//                               child: Container(
//                                   color: Colors.white.withOpacity(0.1),
//                                   width: MediaQuery.of(context).size.width*0.85,
//                                   height: MediaQuery.of(context).size.height*0.055,
//                                   child: Padding(
//                                   padding: EdgeInsets.only(left: 10, right: 10),
//                                   child: TextFormField(

//                                     controller: controllerList[i],
//                                     // initialValue: "hey",
//                                     // keyboardType: TextInputType.multiline,
//                                     // maxLines: null,
//                                     // expands: true,
//                                     // minLines: null,
//                                     onChanged: (value)  {

//                                         // if whatever was entered was cleaned after wards ,
//                                         // that data is deleted from the options
//                                         // and the list view builder is reduced by one

//                                         if(value == ""){

//                                           // This place just removes focus from the current
//                                           //text widget. This makes the underground operation cleaner
//                                           FocusScopeNode currentFocus = FocusScope.of(context);

//                                           if(!currentFocus.hasPrimaryFocus){
//                                             currentFocus.unfocus();
//                                           }

//                                           setState(() {

//                                             if(optionsNumber > 1){

//                                               print(" One of the options has been removed");
//                                               --optionsNumber;

//                                               // removes the controller at tha particular index
//                                               controllerList.removeAt(i);
                                              
//                                             }
                                            
//                                           });

//                                           // Remove the controller and the option at that index where the question was wiped
//                                             questionDetails.options!.removeAt(i);
//                                             // controllerList.removeAt(i);
                                            
//                                             // if the option that was removed is currently holding the answer
//                                             // unclick every other radio button
//                                             if(groupValue == i){
//                                               groupValue = -1;
                                              
//                                             } 

//                                             // changes the answer selected back to false if the current question is
//                                             // being wipped away
//                                             answerSelected = false;
//                                         }

//                                         else{
                                          
//                                         // checks if the position on this index is filled
                                        
//                                         // if it is filled, it replaces what ever value that was there before
//                                         if(questionDetails.options!.asMap().containsKey(i)){

//                                           questionDetails.options![i] = {value: groupValue ==i? true: false};
//                                         }

//                                         // if it is empty, insert to that position
//                                         else{

//                                         questionDetails.options!.insert(i, {value: groupValue ==i? true: false});
//                                         }
                                          
//                                         }
//                                     },
//                                     style: const TextStyle(
//                                       color: Colors.white
//                                     ),
//                                     decoration: const InputDecoration(
                                      
//                                       hintText: "Enter Option Here",
//                                       hintStyle: TextStyle(
//                                         color: Colors.white38
//                                       ),
                                      
//                                       border: InputBorder.none,
//                                       focusedBorder: InputBorder.none
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         );
//                       }),
//                     ),

//                     SizedBox(height: MediaQuery.of(context).size.height* 0.03),

//                     Container(
//                           height: 40,
//                           width: MediaQuery.of(context).size.width*0.4,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors. orange
//                           ),
//                           child: InkWell(
//                             onTap: (){

//                               // the first check to ensure that a question is filled in
//                               if(_newTestController.text.isNotEmpty){

//                                   // the second check to ensure that there is atleast on option
//                                   if(questionDetails.options!.isNotEmpty){
                                    

//                                     // checks if an answer is selected
//                                     if(answerSelected){

//                                       // creates a hivebox instance to write a course and question into local database
//                                       final courseBox = Hive.box('courseCodes');
//                                       final questionsBox = Hive.box('quizQuestions');

//                                       // fetch the data from the course code box
//                                       Iterable<CourseModel> coursePreset = courseBox.values
//                                         .toList()
//                                         .where((element) => element.courseId == courseUniqueId)
//                                         .cast<CourseModel>();

//                                       // checks if there was any other course saved with this id. if there is, it just saves only the question
//                                       // else, it saves the question and the course

//                                       // fires if there is no course code with this unique id present in the database
//                                       if(coursePreset.isEmpty){

//                                         print(coursePreset);
//                                         courseBox.add(courseDetails).then(
//                                         (value) {

//                                           questionsBox.add(questionDetails).then(
//                                             (value)  {

//                                               print("Did not find any course in the database. Added both course and question");
//                                               myWidgets.showToast(message: "Question added successfully");

//                                               _newTestController.text = "";
//                                               controllerList.clear();
//                                               controllerList.add(TextEditingController());
//                                               questionDetails.options!.clear();
//                                               questionDetails.question = "";

//                                               setState(() {
//                                                 print(controllerList.length);
//                                                 print(questionDetails.options!);


//                                                 FocusScopeNode currentFocus = FocusScope.of(context);
//                                                   if(!currentFocus.hasPrimaryFocus){
//                                                     currentFocus.unfocus();
//                                                   }
//                                                 answerSelected = false;
//                                                 groupValue = -1;
//                                                 optionsNumber = 1;
//                                               });
                                              
//                                             }
//                                           );
//                                         }
//                                       );
//                                       }

//                                       // fires if there is already a course code present with the unique id generated
//                                       else{

//                                         print(coursePreset);

//                                         questionsBox.add(questionDetails).then(
//                                             (value)  {

//                                               print("found course in the database and added only question");
//                                               myWidgets.showToast(message: "Question added successfully");
//                                               _newTestController.text = "";
//                                               controllerList.clear();
//                                               controllerList.add(TextEditingController());
//                                               questionDetails.options!.clear();
//                                               questionDetails.question = "";

//                                               setState(() {
//                                                 print(controllerList.length);
//                                                 print(questionDetails.options!);

//                                                 FocusScopeNode currentFocus = FocusScope.of(context);
//                                                   if(!currentFocus.hasPrimaryFocus){
//                                                     currentFocus.unfocus();
//                                                   }
                                                  
//                                                 answerSelected = false;
//                                                 groupValue = -1;
//                                                 optionsNumber = 1;
//                                               });

//                                             }
//                                           );
//                                       }
                                      
//                                       // print(questionDetails.question);
//                                       // print(questionDetails.options);
//                                       // print("The Unique id is ${courseUniqueId} ");

                                      
//                                     }
                                    

//                                     // runs if no answer is currently selected
//                                     else{
//                                       myWidgets.showToast(message: "Select on option as an answer");
//                                     }

//                                   }

//                                   // runs if there is no option selected
//                                   else{
//                                     myWidgets.showToast(message: "Please insert at least one option");
//                                   }
//                               }
                              
//                               // runs if there is no question inputed
//                               else{
//                                 myWidgets.showToast(message: "Please Enter a question ");
//                               }
//                             },
//                             child: const Center(
//                               child: Text("DONE",
//                                 style:TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w300,
//                                 fontSize: 18
//                                                 ),),
//                             ),
//                           ),
//                         ),

            
//           ],
//         ),
//       ),
//     );
//   }
// }