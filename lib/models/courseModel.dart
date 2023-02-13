
import 'package:hive/hive.dart';
part 'courseModel.g.dart';

@HiveType(typeId: 2)
class CourseModel {
  
  @HiveField(0)
  String courseId;

  @HiveField(1)
  String courseCode;

  CourseModel({required this.courseId, required this.courseCode});
}