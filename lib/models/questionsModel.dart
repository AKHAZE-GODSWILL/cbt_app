import 'package:hive/hive.dart';
part 'questionsModel.g.dart';

@HiveType(typeId: 1)
class QuestionsModel{
  
  @HiveField(0)
  String id;

  @HiveField(1)
  String? question;

  @HiveField(2)
  List<Map<String, bool>>? options;

  // the constructor for this class 
  QuestionsModel({required this.id, required this.question, required this.options});
}
