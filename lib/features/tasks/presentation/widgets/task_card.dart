import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';
import '../../data/models/task.dart' as task_model;

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback? onToggleComplete; // معامل جديد

  const TaskCard({super.key, required this.task, this.onToggleComplete});

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == task_model.TaskStatus.completed;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          onPressed: onToggleComplete,
          tooltip: isCompleted ? 'تراجع عن الإنجاز' : 'تحديد كمُنجز',
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: task.dueDate != null
            ? Text(
                '${task.dueDate!.toLocal()}'.split(' ')[0],
                style: const TextStyle(fontSize: 12),
              )
            : null,
        trailing: _buildPriorityIcon(task.priority),
        onTap: onToggleComplete,
      ),
    );
  }

  Widget _buildPriorityIcon(task_model.Priority priority) {
    switch (priority) {
      case task_model.Priority.high:
        return const Icon(Icons.priority_high, color: Colors.red);
      case task_model.Priority.medium:
        return const Icon(Icons.circle, color: Colors.orange, size: 16);
      case task_model.Priority.low:
        return const Icon(Icons.circle, color: Colors.green, size: 16);
    }
  }
}
