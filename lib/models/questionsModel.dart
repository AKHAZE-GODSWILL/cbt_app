import 'package:hive/hive.dart';
part 'questionsModel.g.dart';

@HiveType(typeId: 1)
class QuestionsModel{
  
  @HiveField(0)
  String id;

  @HiveField(1)
  String courseId;

  @HiveField(2)
  String? question;

  @HiveField(3)
  List<Map<String, bool>>? options;

  @HiveField(4)
  DateTime timestamp;

  // the constructor for this class 
  QuestionsModel({required this.id,required this.courseId, required this.question, required this.options, required this.timestamp});

}
