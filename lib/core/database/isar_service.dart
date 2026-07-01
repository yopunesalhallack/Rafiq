import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/tasks/data/models/task.dart';
import '../../features/goals/data/models/goal.dart';
import '../../features/goals/data/models/milestone.dart';

class IsarService {
  static Future<Isar>? _dbFuture; // تخزين العملية المستقبلية

  Future<Isar> get db {
    if (_dbFuture != null) return _dbFuture!;
    _dbFuture = _open();
    return _dbFuture!;
  }

  Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [TaskSchema, GoalSchema, MilestoneSchema],
      directory: dir.path,
      inspector: true,
    );
  }
}
