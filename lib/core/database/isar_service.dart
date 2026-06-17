import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/tasks/data/models/task.dart';
import '../../features/goals/data/models/goal.dart';
import '../../features/goals/data/models/milestone.dart';

class IsarService {
  Future<Isar> get db => _openDB();

  Future<Isar> _openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open([
      TaskSchema,
      GoalSchema,
      MilestoneSchema,
    ], directory: dir.path);
  }
}
