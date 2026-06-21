import '../entities/task_entity.dart';

abstract class TaskRepository {
  Future<void> addTask(TaskEntity task);
  Future<List<TaskEntity>> getTodayTasks();
  Future<List<TaskEntity>> getTasks({TaskFilter? filter});
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(int taskId);
  Future<List<TaskEntity>> getTasksForGoal(int goalId);
  Future<TaskEntity?> getTaskById(int id);
}

enum TaskFilter { today, upcoming, all }
