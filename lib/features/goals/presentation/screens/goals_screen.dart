import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq_app/core/utils/locale_provider.dart';
import 'package:rafiq_app/features/goals/data/models/goal.dart';
import 'package:rafiq_app/features/goals/presentation/widgets/add_goal_bottom_sheet.dart';
import 'package:rafiq_app/home_screen.dart';
import 'package:rafiq_app/l10n/app_localizations.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);
const Color kProgressOrange = Color(0xFFF5A623);

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsStreamProvider);
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.from(alpha: 1, red: 0.89, green: 0.957, blue: 0.965),
                Color.fromARGB(255, 162, 234, 236),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(l10n),
                const SizedBox(height: 20),
                Expanded(
                  child: goalsAsync.when(
                    data: (goals) {
                      if (goals.isEmpty) {
                        return Center(child: Text(l10n.noGoalsYet));
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        itemCount: goals.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final goal = goals[index];
                          return InkWell(
                            onTap: () =>
                                context.push('/goal-details', extra: goal),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.08),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${goal.progressPercent}%',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        goal.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: goal.progressPercent / 100,
                                      minHeight: 6,
                                      backgroundColor: Colors.grey[200],
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            kPrimaryColor,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        goal.targetDate
                                                ?.toIso8601String()
                                                .substring(0, 10) ??
                                            l10n.unknownDate,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        goal.status == GoalStatus.active
                                            ? l10n.inProgress
                                            : l10n.completedStatus,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(
                      child: Text(
                        l10n.errorLoadingData.replaceFirst(
                          r'$error',
                          err.toString(),
                        ),
                      ),
                    ),
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
              builder: (context) => const AddGoalBottomSheet(),
            );
          },
          backgroundColor: const Color(0xFF27A4A7),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildHeader(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings_outlined, size: 26),
          ),
          Text(
            l10n.myGoals,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
