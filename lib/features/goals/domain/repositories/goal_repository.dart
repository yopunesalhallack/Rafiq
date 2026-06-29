import '../../data/models/goal.dart';

abstract class GoalRepository {
  //  Stream
  Stream<List<Goal>> watchGoals();
  Future<void> addGoal(Goal goal);
  Future<void> updateGoal(Goal goal);
  Future<void> deleteGoal(int id);
  Future<Goal> getGoal(int goalId);
}
