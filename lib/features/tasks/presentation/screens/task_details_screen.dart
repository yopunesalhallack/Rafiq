import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';

class TaskDetailsPage extends StatelessWidget {
  final TaskEntity task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        title: const Text("تفاصيل المهمة"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            if (task.description != null)
              Text(
                task.description!,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),

            const SizedBox(height: 20),

            _infoTile("الحالة", task.status.name),
            _infoTile("الأولوية", task.priority.name),
            _infoTile("تاريخ الإنشاء", task.createdAt.toString()),

            if (task.dueDate != null)
              _infoTile("تاريخ الاستحقاق", task.dueDate.toString()),

            const Spacer(),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              icon: const Icon(Icons.delete),
              label: const Text("حذف المهمة"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
