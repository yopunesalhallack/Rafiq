import 'package:rafiq_app/features/tasks/data/models/task.dart';
import 'package:rafiq_app/features/tasks/domain/entities/task_entity.dart';

import '../repositories/task_repository.dart';

class UpdateTaskStatusUseCase {
  final TaskRepository repository;

  UpdateTaskStatusUseCase(this.repository);

  Future<void> call(int taskId, TaskStatus newStatus) async {
    final task = await repository.getTaskById(taskId);
    if (task != null) {
      final updatedTask = TaskEntity(
        id: task.id,
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        priority: task.priority,
        status: newStatus,
        reminderTime: task.reminderTime,
        goalId: task.goalId,
        milestoneId: task.milestoneId,
      );
      await repository.updateTask(updatedTask);
    }
  }
}
