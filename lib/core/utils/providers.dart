import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/isar_service.dart';
import '../../features/goals/domain/repositories/goal_repository.dart';
import '../../features/goals/data/repositories/goal_repository_impl.dart';
import '../../features/tasks/domain/repositories/task_repository.dart';
import '../../features/tasks/data/repositories/task_repository_impl.dart';

// Isar provider
final isarServiceProvider = Provider<IsarService>((ref) => IsarService());
final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepositoryImpl(ref.watch(isarServiceProvider)),
);
final taskRepositoryProvider = Provider<TaskRepository>(
  (ref) => TaskRepositoryImpl(ref.watch(isarServiceProvider)),
);
