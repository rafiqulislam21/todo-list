//@HiveType(typeId: 0)
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class TasksModel extends HiveObject {
  @HiveField(0)
  String taskName;

  @HiveField(1)
  DateTime taskDate;

  @HiveField(2)
  bool isComplete;
}