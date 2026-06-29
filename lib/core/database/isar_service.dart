import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/tasks/data/models/task.dart';
import '../../features/goals/data/models/goal.dart';
import '../../features/goals/data/models/milestone.dart';

class IsarService {
  Isar? _isar;

  Future<Isar> get db async {
    if (_isar != null) return _isar!;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [TaskSchema, GoalSchema, MilestoneSchema],
      directory: dir.path,
      inspector: true,
    );
    return _isar!;
  }
}
