import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rafiq_app/core/utils/service_locator.dart';
import 'package:rafiq_app/features/tasks/data/models/task.dart';
import 'package:rafiq_app/features/tasks/domain/repositories/task_repository.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);

class AddTaskBottomSheet extends StatefulWidget {
  final int? goalId;

  const AddTaskBottomSheet({super.key, this.goalId});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _dueDate;
  Priority _selectedPriority = Priority.medium;
  TaskStatus _selectedStatus = TaskStatus.pending;

  final TaskRepository _taskRepository = getIt<TaskRepository>();

  // pick date&time
  Future<void> _pickDateAndTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    setState(() {
      _dueDate = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _saveTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال عنوان المهمة')));
      return;
    }

    final newTask = Task()
      ..title = _titleController.text.trim()
      ..description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim()
      ..dueDate = _dueDate
      ..priority = _selectedPriority
      ..status = _selectedStatus
      ..goalId = widget.goalId
      ..isSynced = false
      ..createdAt = DateTime.now();

    await _taskRepository.addTask(newTask);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'إضافة مهمة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'عنوان المهمة',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Description
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'وصف المهمة (اختياري)',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Due Date & Time Picker
            InkWell(
              onTap: _pickDateAndTime,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    Text(
                      _dueDate != null
                          ? '${_dueDate!.year}-${_dueDate!.month.toString().padLeft(2, '0')}-${_dueDate!.day.toString().padLeft(2, '0')}  ${_dueDate!.hour.toString().padLeft(2, '0')}:${_dueDate!.minute.toString().padLeft(2, '0')}'
                          : 'تاريخ ووقت الاستحقاق (اختياري)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Priority Dropdown
            DropdownButtonFormField<Priority>(
              initialValue: _selectedPriority,
              decoration: InputDecoration(
                labelText: 'الأولوية',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: Priority.values.map((priority) {
                String label;
                switch (priority) {
                  case Priority.low:
                    label = 'منخفضة';
                    break;
                  case Priority.medium:
                    label = 'متوسطة';
                    break;
                  case Priority.high:
                    label = 'عالية';
                    break;
                }
                return DropdownMenuItem<Priority>(
                  value: priority,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedPriority = value);
              },
            ),
            const SizedBox(height: 12),

            // Status Dropdown
            DropdownButtonFormField<TaskStatus>(
              initialValue: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'حالة المهمة',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: TaskStatus.values.map((status) {
                String label;
                switch (status) {
                  case TaskStatus.pending:
                    label = 'لم تبدأ بعد';
                    break;
                  case TaskStatus.inProgress:
                    label = 'قيد التنفيذ';
                    break;
                  case TaskStatus.completed:
                    label = 'مكتملة';
                    break;
                  case TaskStatus.postponed:
                    label = 'مؤجلة';
                    break;
                }
                return DropdownMenuItem<TaskStatus>(
                  value: status,
                  child: Text(label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedStatus = value);
              },
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'إضافة مهمة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
