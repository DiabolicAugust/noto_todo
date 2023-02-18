import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo {
  Todo(
      {required this.title,
      required this.dateOfCreation,
      required this.isDone});

  @HiveField(0)
  String title;

  @HiveField(1)
  String dateOfCreation;

  @HiveField(2)
  bool isDone;
}
