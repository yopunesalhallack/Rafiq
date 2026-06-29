import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq_app/core/utils/service_locator.dart';
import 'package:rafiq_app/features/goals/domain/repositories/goal_repository.dart';
import 'package:rafiq_app/features/goals/presentation/screens/addgoal_widget.dart';
import '../../../tasks/domain/repositories/task_repository.dart';
import '../../../tasks/data/models/task.dart';
import '../../../goals/data/models/goal.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);
const Color kProgressOrange = Color(0xFFF5A623);

class GoalDetailsScreen extends StatefulWidget {
  const GoalDetailsScreen({super.key});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  late Goal _goal;
  List<Task> _tasks = [];
  bool _isLoading = true;
  bool _initialized = false;

  final TaskRepository _taskRepository = getIt<TaskRepository>();
  final GoalRepository _goalRepository = getIt<GoalRepository>();

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
        _loadTasks();
      }
    } else if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.pop();
      });
    }
  }

  Future<void> _loadTasks() async {
    final tasksStream = _taskRepository.watchTasksForGoal(_goal.id);
    tasksStream.listen((tasks) {
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _toggleTask(Task task) async {
    task.status = task.status == TaskStatus.completed
        ? TaskStatus.pending
        : TaskStatus.completed;
    await _taskRepository.updateTask(task);
    final updatedGoal = await _goalRepository.getGoal(_goal.id);
    if (mounted) {
      setState(() {
        _goal = updatedGoal;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _buildSmartPlanSection(),
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

  Widget _buildSmartPlanSection() {
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
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_tasks.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('لا توجد مهام فرعية لهذا الهدف بعد'),
              ),
            )
          else
            ..._tasks.map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    final bool isCompleted = task.status == TaskStatus.completed;
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isCompleted ? kGreyText : kDarkText,
              decoration: isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
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
    );
  }

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
