import 'package:rafiq_app/features/tasks/data/models/task.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(int taskId);

  //get all  tasks
  Stream<List<Task>> watchAllTasks();
  //get task by goal id
  Stream<List<Task>> watchTasksForGoal(int goalId);
}
