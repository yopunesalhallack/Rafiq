import 'package:isar_community/isar.dart';

import '../models/task.dart';

class TaskLocalDataSource {
  final Isar isar;

  TaskLocalDataSource(this.isar);

  Future<List<Task>> getTasks() async {
    return await isar.tasks.where().sortByCreatedAtDesc().findAll();
  }

  Future<int> addTask(Task task) async {
    return await isar.writeTxn(() async {
      return await isar.tasks.put(task);
    });
  }

  Future<void> deleteTask(int id) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
  }

  Future<void> updateTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  Future<Task?> getTask(int id) async {
    return await isar.tasks.get(id);
  }
}
