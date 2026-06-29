import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/service_locator.dart';
import '../../features/goals/domain/repositories/goal_repository.dart';
import '../../features/goals/data/models/goal.dart';
import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/data/models/task.dart';

// الألوان
const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);
const Color kLightBackground = Color(0xFFF6FAFB);
const Color kProgressGreen = Color(0xFF4CB6B6);
const Color kProgressOrange = Color(0xFFF5A623);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // حقن الـ Repositories
  final GoalRepository _goalRepository = getIt<GoalRepository>();
  final TaskRepository _taskRepository = getIt<TaskRepository>();

  // إحصائيات الصفحة
  int _averageProgress = 0;
  int _completedTasks = 0;
  int _totalTasks = 0;
  int _completedGoals = 0;
  int _totalGoals = 0;
  List<Task> _incompleteTasks = [];
  bool _isLoading = true;

  StreamSubscription? _goalSubscription;
  StreamSubscription? _taskSubscription;

  @override
  void initState() {
    super.initState();
    _listenToData();
  }

  void _listenToData() {
    //  listen to goals
    _goalSubscription = _goalRepository.watchGoals().listen((goals) {
      if (mounted) {
        _updateStatsFromGoals(goals);
      }
    });

    //   listen to tasks
    _taskSubscription = _taskRepository.watchAllTasks().listen((tasks) {
      if (mounted) {
        _updateStatsFromTasks(tasks);
      }
    });
  }

  void _updateStatsFromGoals(List<Goal> goals) {
    setState(() {
      _totalGoals = goals.length;
      if (_totalGoals > 0) {
        final sum = goals.fold<int>(0, (s, g) => s + g.progressPercent);
        _averageProgress = (sum / _totalGoals).round();
        _completedGoals = goals
            .where((g) => g.status == GoalStatus.completed)
            .length;
      } else {
        _averageProgress = 0;
        _completedGoals = 0;
      }
      _isLoading = false;
    });
  }

  void _updateStatsFromTasks(List<Task> tasks) {
    setState(() {
      _totalTasks = tasks.length;
      _completedTasks = tasks
          .where((t) => t.status == TaskStatus.completed)
          .length;
      _incompleteTasks = tasks
          .where((t) => t.status != TaskStatus.completed)
          .toList();
    });
  }

  @override
  void dispose() {
    _goalSubscription?.cancel();
    _taskSubscription?.cancel();
    super.dispose();
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
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color.from(alpha: 1, red: 0.89, green: 0.957, blue: 0.965),
                Color.fromARGB(255, 162, 234, 236),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  _buildHeader(context),
                  const SizedBox(height: 20),
                  _buildProgressCard(),
                  const SizedBox(height: 24),
                  _buildTaskSection(),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'مرحباً أحمد!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: kDarkText,
            ),
          ),
          GestureDetector(
            onTap: () {
              context.push('/notifications');
            },
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_outlined,
                  size: 30,
                  color: kPrimaryColor,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final String todayProgressText = '$_averageProgress%';
    final String tasksText = '$_completedTasks/$_totalTasks';
    final String goalsText = _totalGoals > 0
        ? '${(_completedGoals / _totalGoals * 100).round()}%'
        : '0%';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildProgressCircle(
            _averageProgress / 100,
            todayProgressText,
            'تقدم اليوم',
            kPrimaryColor,
          ),
          _buildProgressCircle(
            _totalTasks > 0 ? _completedTasks / _totalTasks : 0,
            tasksText,
            'المهام المنجزة',
            kProgressGreen,
          ),
          _buildProgressCircle(
            _totalGoals > 0 ? _completedGoals / _totalGoals : 0,
            goalsText,
            'نسبة للأهداف القادرة',
            kProgressOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(
    double value,
    String text,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 6,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
              Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kDarkText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: kGreyText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskSection() {
    if (_isLoading) {
      return const SizedBox();
    }

    //display 3latest tasks

    final displayTasks = _incompleteTasks.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مهام اليوم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // rout to goals detils : add a button to back to the home
                  context.push('/goals');
                },
                child: const Text(
                  'المزيد',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (displayTasks.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'لا توجد مهام حالياً، أضف مهمة جديدة!',
                  style: TextStyle(color: kGreyText),
                ),
              ),
            ),
          ...displayTasks.map((task) {
            // progress persintage
            double progress = task.status == TaskStatus.completed ? 1.0 : 0.0;

            return _buildTaskItem(
              task.title,
              progress,
              task.status == TaskStatus.completed,
            );
          }),
          if (displayTasks.isEmpty) const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, double progress, bool isChecked) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kDarkText,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  //  check box
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isChecked ? kPrimaryColor : Colors.transparent,
                      border: Border.all(
                        color: isChecked ? kPrimaryColor : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
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
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAITipCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_back_ios_new, size: 16, color: kPrimaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'AI Tip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kDarkText,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.auto_awesome, size: 18, color: kPrimaryColor),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'مساعدك الذكي لإنجاز أهدافك وتنظيم حياتك.',
                  style: TextStyle(fontSize: 14, color: kGreyText, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
