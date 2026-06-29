import 'package:isar_community/isar.dart';
part 'goal.g.dart';

@Collection()
class Goal {
  Id id = Isar.autoIncrement;
  String? serverId;
  bool isSynced = false;
  DateTime? lastUpdated;
  late String title;
  String? description;
  DateTime? targetDate;
  @enumerated
  GoalStatus status = GoalStatus.active;
  int progressPercent = 0;
  bool isAiEnabled = false;
  DateTime createdAt = DateTime.now();
}

enum GoalStatus { active, completed, abandoned }
