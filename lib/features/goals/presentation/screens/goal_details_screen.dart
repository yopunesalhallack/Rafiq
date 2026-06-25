import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//   const colors
const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);
const Color kProgressOrange = Color(0xFFF5A623);

class GoalDetailsScreen extends StatelessWidget {
  const GoalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final Map<String, dynamic> goalData = GoRouterState.of(context).extra as Map<String, dynamic>;
    // temo data
    final goalData = {
      'title': 'تعلم اللغة الفرنسية',
      'subtitle': 'أساسيات اللغة',
      'percentage': 60,
      'date': '2023 - 2024',
      'status': 'انتهى العمل',
      'progressColor': kPrimaryColor,
      'stages': [
        {
          'title': 'المرحلة الأولى: القواعد الأساسية',
          'percentage': 80,
          'tasks': [
            {'title': 'قواعد اللغة الأساسية', 'completed': true},
            {'title': 'قواعد اللغة المتقدمة', 'completed': false},
            {'title': 'قواعد المحادثة', 'completed': false},
          ],
        },
        {'title': 'المرحلة الثانية: المحادثة', 'percentage': 40, 'tasks': []},
      ],
    };

    return Directionality(
      textDirection: TextDirection.ltr,
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
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 20),

                  _buildGoalMainCard(goalData),

                  const SizedBox(height: 24),

                  _buildSmartPlanSection(goalData['stages'] as List),

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
            onPressed: () {
              context.pop();
            },
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

  Widget _buildGoalMainCard(Map<String, dynamic> goal) {
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
          // العنوان والنسبة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${goal['percentage']}%',
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
                    goal['title'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kDarkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    goal['subtitle'],
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
              value: goal['percentage'] / 100,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(goal['progressColor']),
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
                    goal['status'],
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
                    goal['date'],
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

  Widget _buildSmartPlanSection(List<dynamic> stages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الخطة الذكية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkText,
            ),
          ),
          const SizedBox(height: 16),

          ...stages.asMap().entries.map((entry) {
            int index = entry.key;
            var stage = entry.value;
            return _buildStageItem(stage, isFirst: index == 0);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStageItem(Map<String, dynamic> stage, {required bool isFirst}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${stage['percentage']}%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                ),
              ),
              Text(
                stage['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stage['percentage'] / 100,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),

          if (isFirst &&
              stage['tasks'] != null &&
              (stage['tasks'] as List).isNotEmpty) ...[
            const SizedBox(height: 16),
            ...(stage['tasks'] as List).map((task) {
              return _buildTaskItem(task['title'], task['completed']);
            }).toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isCompleted ? kDarkText : kGreyText,
            ),
          ),
          Container(
            width: 22,
            height: 22,
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
