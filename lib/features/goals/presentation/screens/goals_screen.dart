import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq_app/features/goals/presentation/screens/addgoal_widget.dart';
import 'goal_details_screen.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);
const Color kProgressOrange = Color(0xFFF5A623);

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //   temp data
    final List<Map<String, dynamic>> goals = [
      {
        'title': 'تعلم اللغة الفرنسية',
        'subtitle': 'أساسيات اللغة',
        'percentage': 60,
        'progressColor': kPrimaryColor,
        'date': '2023 - 2033',
        'status': 'انتهى العمل',
        'avatars': [Colors.blue.shade300],
      },
      {
        'title': 'إنشاء متجر إلكتروني',
        'subtitle': 'التسويق الإلكتروني',
        'percentage': 35,
        'progressColor': kProgressOrange,
        'date': '2023 - 2033',
        'status': 'قيد التنفيذ',
        'avatars': [Colors.orange.shade300, Colors.purple.shade300],
      },
    ];

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
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    itemCount: goals.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return _buildGoalCard(
                        context: context,
                        goalData: goal,
                        title: goal['title'],
                        subtitle: goal['subtitle'],
                        percentage: goal['percentage'],
                        progressColor: goal['progressColor'],
                        status: goal['status'],
                        date: goal['date'],
                        avatarColors: goal['avatars'],
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
              builder: (BuildContext context) {
                return const AddTaskBottomSheet();
              },
            );
          },
          backgroundColor: kPrimaryColor,
          elevation: 4,
          shape: const CircleBorder(),
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
            icon: const Icon(
              Icons.settings_outlined,
              size: 26,
              color: kDarkText,
            ),
          ),
          const Text(
            'أهدافك',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: kDarkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required BuildContext context,
    required Map<String, dynamic> goalData,
    required String title,
    required String subtitle,
    required int percentage,
    required Color progressColor,
    required String status,
    required String date,
    required List<Color> avatarColors,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      //   action for card
      onTap: () {
        context.push(
          '/goal-details',
          extra: goalData, // should use api to get data from db
        );
      },
      child: Container(
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
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkText,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kDarkText,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 13, color: kGreyText),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percentage / 100,
                minHeight: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: kGreyText,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      date,
                      style: const TextStyle(fontSize: 12, color: kGreyText),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: kGreyText),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: const TextStyle(fontSize: 12, color: kGreyText),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: avatarColors.map((color) {
                return Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
