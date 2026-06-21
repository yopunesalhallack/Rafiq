import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiq_app/features/tasks/data/models/task.dart';
import 'package:rafiq_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:rafiq_app/features/tasks/presentation/providers/taskListNotifier.dart';
import 'package:rafiq_app/features/tasks/presentation/screens/task_details_screen.dart';
import '../../domain/entities/task_entity.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(taskListNotifierProvider);
    final notifier = ref.read(taskListNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "مهامي",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ),

      body: Column(
        children: [
          _buildFilterBar(notifier, state.filter),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: state.loading
                  ? const Center(child: CircularProgressIndicator())
                  : state.tasks.isEmpty
                  ? const Center(
                      child: Text(
                        "لا توجد مهام",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.tasks.length,
                      itemBuilder: (context, index) {
                        final task = state.tasks[index];
                        return _TaskCard(task: task);
                      },
                    ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE67E22),
        onPressed: () => showAddTaskSheet(context, notifier),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildFilterBar(TaskListNotifier notifier, TaskFilter selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _filterChip("الكل", TaskFilter.all, selected, notifier),
          const SizedBox(width: 8),
          _filterChip("اليوم", TaskFilter.today, selected, notifier),
          const SizedBox(width: 8),
          _filterChip("القادمة", TaskFilter.upcoming, selected, notifier),
        ],
      ),
    );
  }

  Widget _filterChip(
    String label,
    TaskFilter filter,
    TaskFilter selected,
    TaskListNotifier n,
  ) {
    final bool active = filter == selected;

    return GestureDetector(
      onTap: () => n.loadTasks(filter: filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE67E22) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (active)
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void showAddTaskSheet(BuildContext context, TaskListNotifier notifier) {
    final title = TextEditingController();
    final desc = TextEditingController();

    Priority priority = Priority.medium;
    DateTime? dueDate;
    TimeOfDay? reminderTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "إضافة مهمة جديدة",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: title,
                      decoration: const InputDecoration(
                        labelText: "عنوان المهمة",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: desc,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: "الوصف",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "الأولوية",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        _priorityChip(
                          "منخفضة",
                          Priority.low,
                          priority,
                          setState,
                        ),
                        const SizedBox(width: 8),
                        _priorityChip(
                          "متوسطة",
                          Priority.medium,
                          priority,
                          setState,
                        ),
                        const SizedBox(width: 8),
                        _priorityChip(
                          "عالية",
                          Priority.high,
                          priority,
                          setState,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ListTile(
                      title: Text(
                        dueDate == null
                            ? "اختر تاريخ الاستحقاق"
                            : "تاريخ الاستحقاق: ${dueDate!.toLocal()}".split(
                                ' ',
                              )[0],
                      ),
                      trailing: const Icon(Icons.calendar_month),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => dueDate = picked);
                        }
                      },
                    ),

                    ListTile(
                      title: Text(
                        reminderTime == null
                            ? "تفعيل التذكير"
                            : "التذكير: ${reminderTime!.format(context)}",
                      ),
                      trailing: const Icon(Icons.alarm),
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          setState(() => reminderTime = picked);
                        }
                      },
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: const Color(0xFFE67E22),
                      ),
                      onPressed: () {
                        notifier.addNewTask(
                          TaskEntity(
                            title: title.text,
                            description: desc.text,
                            priority: priority,
                            dueDate: dueDate,
                            reminderTime: reminderTime == null
                                ? null
                                : DateTime(
                                    dueDate?.year ?? DateTime.now().year,
                                    dueDate?.month ?? DateTime.now().month,
                                    dueDate?.day ?? DateTime.now().day,
                                    reminderTime!.hour,
                                    reminderTime!.minute,
                                  ),
                            createdAt: DateTime.now(),
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: const Text("حفظ", style: TextStyle(fontSize: 18)),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _priorityChip(
    String label,
    Priority value,
    Priority selected,
    void Function(void Function()) setState,
  ) {
    final active = value == selected;

    return GestureDetector(
      onTap: () => setState(() => selected = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFE67E22) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TaskCard extends ConsumerWidget {
  final TaskEntity task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskListNotifierProvider.notifier);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => TaskDetailsPage(task: task)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Checkbox(
              value: task.status == TaskStatus.completed,
              onChanged: (_) {
                notifier.updateExistingTask(
                  task.copyWith(
                    status: task.status == TaskStatus.completed
                        ? TaskStatus.pending
                        : TaskStatus.completed,
                  ),
                );
              },
            ),
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  decoration: task.status == TaskStatus.completed
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
