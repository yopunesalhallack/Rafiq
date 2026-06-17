import 'package:isar_community/isar.dart';

part 'milestone.g.dart';

@Collection()
class Milestone {
  Id id = Isar.autoIncrement;
  late String title;
  String? description;
  int orderIndex = 0;
  DateTime? dueDate;
  late int goalId; // أضف late أو قم بتهيئته في المنشئ
  bool completed = false;
}
