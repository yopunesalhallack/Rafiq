import 'package:isar_community/isar.dart';

part 'goal.g.dart';

@Collection()
class Goal {
  Id id = Isar.autoIncrement;
  late String title;
  String? description;
  DateTime? startDate;
  DateTime? targetDate;
  @enumerated
  GoalStatus status = GoalStatus.active;
  int progressPercent = 0; // يتم تحديثه تلقائيًا لاحقًا
  DateTime createdAt = DateTime.now();
}

enum GoalStatus { active, completed, abandoned }
