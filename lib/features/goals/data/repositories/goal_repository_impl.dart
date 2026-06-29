import 'package:isar_community/isar.dart';
import '../../../../core/database/isar_service.dart';
import '../../../goals/data/models/goal.dart';
import '../../../goals/domain/repositories/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final IsarService _isarService;

  GoalRepositoryImpl(this._isarService);

  Future<Isar> get _db async => await _isarService.db;

  @override
  Stream<List<Goal>> watchGoals() {
    final isarFuture = _isarService.db;
    return Stream.fromFuture(isarFuture).asyncExpand((isar) {
      return isar.goals.where().watch(fireImmediately: true);
    });
  }

  @override
  Future<void> addGoal(Goal goal) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.goals.put(goal);
    });
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.goals.put(goal);
    });
  }

  @override
  Future<Goal> getGoal(int goalId) async {
    final db = await _db;
    final goal = await db.goals.where().idEqualTo(goalId).findFirst();
    if (goal == null) throw Exception('الهدف غير موجود');
    return goal;
  }

  @override
  Future<void> deleteGoal(int id) async {
    final db = await _db;
    await db.writeTxn(() async {
      await db.goals.delete(id);
    });
  }
}
