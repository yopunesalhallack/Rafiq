import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq_app/features/goals/presentation/screens/add_task_bottom_sheet.dart';
import 'package:rafiq_app/features/tasks/data/models/task.dart';
import 'package:rafiq_app/features/goals/data/models/goal.dart';

import 'package:rafiq_app/core/utils/providers.dart';
import 'package:rafiq_app/features/tasks/presentation/widgets/edit_task_bottom_sheet.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);

final taskListForGoalProvider = StreamProvider.family<List<Task>, int>((
  ref,
  goalId,
) {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.watchTasksForGoal(goalId);
});

class GoalDetailsScreen extends ConsumerStatefulWidget {
  const GoalDetailsScreen({super.key});

  @override
  ConsumerState<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends ConsumerState<GoalDetailsScreen> {
  late Goal _goal;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is Goal) {
      if (!_initialized || _goal.id != extra.id) {
        _goal = extra;
        _initialized = true;
      }
    } else if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.pop();
      });
    }
  }

  Future<void> _toggleTask(Task task) async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final goalRepo = ref.read(goalRepositoryProvider);

    task.status = task.status == TaskStatus.completed
        ? TaskStatus.pending
        : TaskStatus.completed;
    await taskRepo.updateTask(task);

    final updatedGoal = await goalRepo.getGoal(_goal.id);
    if (mounted) {
      setState(() {
        _goal = updatedGoal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListForGoalProvider(_goal.id));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.from(alpha: 1, red: 0.89, green: 0.957, blue: 0.965),
                Color.fromARGB(255, 162, 234, 236),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildGoalMainCard(_goal),
                  const SizedBox(height: 24),
                  _buildSmartPlanSection(tasksAsync),
                  const SizedBox(height: 24),
                  _buildAITipCard(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings_outlined,
              size: 26,
              color: kDarkText,
            ),
          ),
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 20,
              color: kDarkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalMainCard(Goal goal) {
    double progress = goal.progressPercent / 100;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${goal.progressPercent}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kDarkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    goal.description ?? 'بدون وصف',
                    style: const TextStyle(fontSize: 14, color: kGreyText),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: kGreyText),
                  const SizedBox(width: 6),
                  Text(
                    goal.status == GoalStatus.active ? 'قيد التنفيذ' : 'مكتمل',
                    style: const TextStyle(fontSize: 14, color: kGreyText),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: kGreyText,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    goal.targetDate?.toIso8601String().substring(0, 10) ??
                        'غير محدد',
                    style: const TextStyle(fontSize: 14, color: kGreyText),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmartPlanSection(AsyncValue<List<Task>> tasksAsync) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الخطة الذكية',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  size: 28,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddTaskBottomSheet(goalId: _goal.id),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('لا توجد مهام فرعية لهذا الهدف بعد'),
                  ),
                );
              }
              return Column(
                children: tasks.map((task) => _buildTaskItem(task)).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (err, stack) =>
                Center(child: Text('خطأ في تحميل المهام: $err')),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    final isCompleted = task.status == TaskStatus.completed;
    final progress = isCompleted ? 1.0 : 0.0;

    // تنسيق التاريخ والوقت
    String dateTimeText = '';
    if (task.dueDate != null) {
      final date = task.dueDate!;
      dateTimeText =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    // تنسيق الأولوية
    String priorityText = '';
    Color priorityColor = kPrimaryColor;
    switch (task.priority) {
      case Priority.low:
        priorityText = 'منخفضة';
        priorityColor = Colors.green;
        break;
      case Priority.medium:
        priorityText = 'متوسطة';
        priorityColor = Colors.orange;
        break;
      case Priority.high:
        priorityText = 'عالية';
        priorityColor = Colors.red;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الصف الأول: العنوان + أزرار التعديل والحذف
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? kGreyText : kDarkText,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  // زر التعديل
                  IconButton(
                    icon: const Icon(
                      Icons.edit_outlined,
                      size: 20,
                      color: kGreyText,
                    ),
                    onPressed: () {
                      // فتح نافذة تعديل المهمة
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => EditTaskBottomSheet(task: task),
                      );
                    },
                  ),
                  // زر الحذف
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      // تأكيد الحذف
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('تأكيد الحذف'),
                          content: const Text(
                            'هل أنت متأكد من حذف هذه المهمة؟',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('إلغاء'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('حذف'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        // حذف المهمة
                        final taskRepo = ref.read(taskRepositoryProvider);
                        await taskRepo.deleteTask(task.id);
                        // لا حاجة لـ setState لأن الـ Stream سيقوم بالتحديث
                      }
                    },
                  ),
                ],
              ),
            ],
          ),

          // الصف الثاني: التاريخ والوقت والأولوية
          if (dateTimeText.isNotEmpty || task.priority != null)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Row(
                children: [
                  if (dateTimeText.isNotEmpty) ...[
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: kGreyText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      dateTimeText,
                      style: const TextStyle(fontSize: 12, color: kGreyText),
                    ),
                  ],
                  if (dateTimeText.isNotEmpty) const SizedBox(width: 12),
                  ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: priorityColor, width: 0.5),
                      ),
                      child: Text(
                        priorityText,
                        style: TextStyle(
                          fontSize: 10,
                          color: priorityColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

          // الصف الثالث: الوصف
          if (task.description != null && task.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                task.description!,
                style: const TextStyle(fontSize: 13, color: kGreyText),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          const SizedBox(height: 10),

          // شريط التقدم
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      kPrimaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // مربع الاختيار (Checkbox)
              GestureDetector(
                onTap: () => _toggleTask(task),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? kPrimaryColor : Colors.transparent,
                    border: Border.all(
                      color: isCompleted ? kPrimaryColor : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildTaskItem(Task task) {
  //   final bool isCompleted = task.status == TaskStatus.completed;
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 12),
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(16),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.withOpacity(0.08),
  //           blurRadius: 8,
  //           spreadRadius: 1,
  //           offset: const Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           task.title,
  //           style: TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w500,
  //             color: isCompleted ? kGreyText : kDarkText,
  //             decoration: isCompleted ? TextDecoration.lineThrough : null,
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: () => _toggleTask(task),
  //           child: Container(
  //             width: 24,
  //             height: 24,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: isCompleted ? kPrimaryColor : Colors.transparent,
  //               border: Border.all(
  //                 color: isCompleted ? kPrimaryColor : Colors.grey[400]!,
  //                 width: 2,
  //               ),
  //             ),
  //             child: isCompleted
  //                 ? const Icon(Icons.check, size: 16, color: Colors.white)
  //                 : null,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAITipCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF9FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_back_ios_new, size: 16, color: kPrimaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'نصيحة AI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kDarkText,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.auto_awesome, size: 18, color: kPrimaryColor),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'صديقك الذكي لتعلم اللغة. هل أنت مستعد لبدء جلسة محادثة جديدة؟',
                  style: TextStyle(fontSize: 14, color: kDarkText, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
