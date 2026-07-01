import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiq_app/core/utils/providers.dart';
import '../../data/models/task.dart';
import '../../domain/repositories/task_repository.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);

class EditTaskBottomSheet extends ConsumerStatefulWidget {
  final Task task;

  const EditTaskBottomSheet({super.key, required this.task});

  @override
  ConsumerState<EditTaskBottomSheet> createState() =>
      _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends ConsumerState<EditTaskBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late DateTime? _dueDateTime;
  late Priority _selectedPriority;
  late TaskStatus _selectedStatus;

  late final TaskRepository _taskRepository;

  @override
  void initState() {
    super.initState();
    // تعبئة الحقول بالبيانات الحالية للمهمة
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );
    _dueDateTime = widget.task.dueDate;
    _selectedPriority = widget.task.priority;
    _selectedStatus = widget.task.status;

    _taskRepository = ref.read(taskRepositoryProvider);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDateTime ?? now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueDateTime ?? now),
    );
    if (pickedTime == null) return;

    setState(() {
      _dueDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _updateTask() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال عنوان المهمة')));
      return;
    }

    // تحديث المهمة بالبيانات الجديدة
    widget.task.title = _titleController.text.trim();
    widget.task.description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();
    widget.task.dueDate = _dueDateTime;
    widget.task.priority = _selectedPriority;
    widget.task.status = _selectedStatus;

    await _taskRepository.updateTask(widget.task);

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
                  'تعديل المهمة',
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

            // Date & Time Picker
            InkWell(
              onTap: _pickDateTime,
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
                      _dueDateTime != null
                          ? '${_dueDateTime!.year}-${_dueDateTime!.month.toString().padLeft(2, '0')}-${_dueDateTime!.day.toString().padLeft(2, '0')}  ${_dueDateTime!.hour.toString().padLeft(2, '0')}:${_dueDateTime!.minute.toString().padLeft(2, '0')}'
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

            // Update Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _updateTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'حفظ التغييرات',
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
