import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';
import '../widgets/task_card.dart';
import '../../data/models/task.dart' as task_model; // استيراد باسم مستعار

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  String _filter = 'الكل';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  task_model.Priority _selectedPriority = task_model.Priority.medium;
  bool _hasReminder = false;
  DateTime? _reminderTime;

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(getTodayTasksProvider);

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatsBar(),
          _buildFilterTabs(),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) => _buildTaskList(tasks),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => _buildErrorWidget(err),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskDialog(),
        icon: const Icon(Icons.add),
        label: const Text('إضافة مهمة'),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'مهام اليوم',
        style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => ref.invalidate(getTodayTasksProvider),
          tooltip: 'تحديث',
        ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFFE67E22), Color(0xFFF39C12)],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    final tasksAsync = ref.watch(getTodayTasksProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.grey.shade50,
      child: tasksAsync.when(
        data: (tasks) {
          final total = tasks.length;
          final completed = tasks
              .where((t) => t.status == task_model.TaskStatus.completed)
              .length;
          final progress = total > 0 ? (completed / total) : 0.0;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('الإجمالي', total.toString(), Colors.blue),
              _buildStatItem('المُنجز', completed.toString(), Colors.green),
              _buildStatItem(
                'المتبقي',
                (total - completed).toString(),
                Colors.orange,
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text('التقدم', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade300,
                      color: progress >= 0.7 ? Colors.green : Colors.orange,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['الكل', 'اليوم', 'معلقة', 'منجزة'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = _filter == filter;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(filter, style: const TextStyle(fontSize: 13)),
                selected: isSelected,
                onSelected: (_) => setState(() => _filter = filter),
                backgroundColor: Colors.grey.shade200,
                selectedColor: const Color(0xFFE67E22).withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<TaskEntity> tasks) {
    final filteredTasks = _filterTasks(tasks);

    if (filteredTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _filter == 'الكل'
                  ? 'لا توجد مهام بعد'
                  : 'لا توجد مهام في هذا التصنيف',
              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              _filter == 'الكل'
                  ? 'أضف مهمتك الأولى الآن'
                  : 'غيّر التصنيف لعرض المهام',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(getTodayTasksProvider),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return Dismissible(
            key: Key(task.id.toString()),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('حذف المهمة'),
                  content: Text('هل أنت متأكد من حذف "${task.title}"؟'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'حذف',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) async {
              final useCase = ref.read(deleteTaskUseCaseProvider);
              await useCase(task.id!);
              ref.invalidate(getTodayTasksProvider);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف "${task.title}"')),
                );
              }
            },
            child: TaskCard(
              task: task,
              onToggleComplete: () async {
                final newStatus = task.status == task_model.TaskStatus.completed
                    ? task_model.TaskStatus.pending
                    : task_model.TaskStatus.completed;
                final useCase = ref.read(updateTaskStatusUseCaseProvider);
                await useCase(task.id!, newStatus);
                ref.invalidate(getTodayTasksProvider);
              },
            ),
          );
        },
      ),
    );
  }

  List<TaskEntity> _filterTasks(List<TaskEntity> tasks) {
    switch (_filter) {
      case 'اليوم':
        final now = DateTime.now();
        final start = DateTime(now.year, now.month, now.day);
        final end = start.add(const Duration(days: 1));
        return tasks.where((t) {
          if (t.dueDate == null) return false;
          return t.dueDate!.isAfter(start) && t.dueDate!.isBefore(end);
        }).toList();
      case 'معلقة':
        return tasks
            .where((t) => t.status != task_model.TaskStatus.completed)
            .toList();
      case 'منجزة':
        return tasks
            .where((t) => t.status == task_model.TaskStatus.completed)
            .toList();
      default:
        return tasks;
    }
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text('حدث خطأ: $error', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => ref.invalidate(getTodayTasksProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedDate = null;
    _selectedTime = null;
    _selectedPriority = task_model.Priority.medium;
    _hasReminder = false;
    _reminderTime = null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text(
              'إضافة مهمة جديدة',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'عنوان المهمة *',
                      hintText: 'مثال: شراء حليب',
                      border: OutlineInputBorder(),
                    ),
                    //textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    autofocus: true,
                    onChanged: (_) => setDialogState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'وصف (اختياري)',
                      hintText: 'تفاصيل إضافية...',
                      border: OutlineInputBorder(),
                    ),
                    //textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildDateButton(setDialogState)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTimeButton(setDialogState)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<task_model.Priority>(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'الأولوية',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: task_model.Priority.low,
                        child: Text('منخفضة'),
                      ),
                      DropdownMenuItem(
                        value: task_model.Priority.medium,
                        child: Text('متوسطة'),
                      ),
                      DropdownMenuItem(
                        value: task_model.Priority.high,
                        child: Text('عالية'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => _selectedPriority = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('تفعيل التذكير'),
                    subtitle: _hasReminder && _reminderTime != null
                        ? Text('التذكير في: ${_formatDateTime(_reminderTime!)}')
                        : null,
                    value: _hasReminder,
                    onChanged: (value) {
                      setDialogState(() {
                        _hasReminder = value ?? false;
                        if (_hasReminder &&
                            _selectedDate != null &&
                            _selectedTime != null) {
                          _reminderTime = DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedTime!.hour,
                            _selectedTime!.minute,
                          ).subtract(const Duration(minutes: 15));
                        }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: _titleController.text.trim().isEmpty
                    ? null
                    : () async {
                        await _saveTask();
                        if (context.mounted) Navigator.pop(context);
                      },
                child: const Text('حفظ'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateButton(void Function(void Function()) setDialogState) {
    return OutlinedButton.icon(
      onPressed: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          // احذف locale أو استخدم الطريقة البديلة
        );
        if (date != null) {
          setDialogState(() => _selectedDate = date);
        }
      },
      icon: const Icon(Icons.calendar_today, size: 16),
      label: Text(
        _selectedDate != null
            ? DateFormat('yyyy/MM/dd', 'ar').format(_selectedDate!)
            : 'اختر التاريخ',
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildTimeButton(void Function(void Function()) setDialogState) {
    return OutlinedButton.icon(
      onPressed: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: _selectedTime ?? TimeOfDay.now(),
          // احذف locale أو استخدم الطريقة البديلة
        );
        if (time != null) {
          setDialogState(() => _selectedTime = time);
        }
      },
      icon: const Icon(Icons.access_time, size: 16),
      label: Text(
        _selectedTime != null ? _selectedTime!.format(context) : 'اختر الوقت',
        textAlign: TextAlign.right,
      ),
    );
  }

  Future<void> _saveTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    DateTime? dueDate;
    if (_selectedDate != null && _selectedTime != null) {
      dueDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );
    }

    final task = TaskEntity(
      title: title,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      dueDate: dueDate,
      priority: _selectedPriority,
      status: task_model.TaskStatus.pending,
      reminderTime: _hasReminder ? _reminderTime : null,
    );

    final useCase = ref.read(addTaskUseCaseProvider);
    await useCase(task);

    ref.invalidate(getTodayTasksProvider);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('✅ تم إضافة "$title" بنجاح')));
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd HH:mm', 'ar').format(dateTime);
  }
}
