import 'package:flutter/material.dart';
import 'package:rafiq_app/core/utils/service_locator.dart';
import 'package:rafiq_app/features/goals/presentation/screens/addgoal_widget.dart';
import '../../data/models/task.dart';
import '../../domain/repositories/task_repository.dart';

class StandaloneTasksScreen extends StatelessWidget {
  StandaloneTasksScreen({super.key});

  final TaskRepository _taskRepository = getIt<TaskRepository>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE3F4F6), Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<List<Task>>(
                    stream: _taskRepository.watchAllTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('خطأ في تحميل المهام'));
                      }

                      final allTasks = snapshot.data ?? [];
                      //  standalone tasks
                      final standaloneTasks = allTasks
                          .where((t) => t.goalId == null)
                          .toList();

                      if (standaloneTasks.isEmpty) {
                        return const Center(
                          child: Text('لا توجد مهام مستقلة، أضف مهمة جديدة!'),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: standaloneTasks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final task = standaloneTasks[index];
                          return _buildTaskCard(context, task);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              //
              builder: (context) => const AddTaskBottomSheet(goalId: null),
            );
          },
          backgroundColor: const Color(0xFF27A4A7),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.task_alt_outlined, size: 26),
          ),
          const Text(
            'المهام المستقلة',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context, Task task) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.status == TaskStatus.completed,
            activeColor: const Color(0xFF27A4A7),
            onChanged: (value) async {
              // update status
              task.status = value == true
                  ? TaskStatus.completed
                  : TaskStatus.pending;
              await _taskRepository.updateTask(task);
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration: task.status == TaskStatus.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                if (task.description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description!,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () async {
              //  delet task
              await _taskRepository.deleteTask(task.id);
            },
          ),
        ],
      ),
    );
  }
}
