import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:rafiq_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:rafiq_app/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:rafiq_app/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:rafiq_app/features/tasks/domain/usecases/get_tasks_usecase.dart';
import 'package:rafiq_app/features/tasks/domain/usecases/update_task_status_usecase.dart';
import '../../../../core/database/isar_service.dart';
import '../../data/repositories/task_repository_impl.dart';
//import '../../domain/usecases/get_today_tasks.dart'; // سننشئه

final isarServiceProvider = FutureProvider<Isar>((ref) {
  final service = IsarService();
  return service.db;
});

final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError("Override Isar instance in main.dart");
});

//task repo

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return TaskRepositoryImpl(isar);
});

// usecases provid4r
final getTasksUseCaseProvider = Provider<GetTasksUseCase>((ref) {
  return GetTasksUseCase(ref.watch(taskRepositoryProvider));
});

final getTodayTasksUseCaseProvider = Provider<GetTodayTasksUseCase>((ref) {
  return GetTodayTasksUseCase(ref.watch(taskRepositoryProvider));
});

final addTaskUseCaseProvider = Provider<AddTaskUseCase>((ref) {
  return AddTaskUseCase(ref.watch(taskRepositoryProvider));
});

final updateTaskUseCaseProvider = Provider<UpdateTaskUseCase>((ref) {
  return UpdateTaskUseCase(ref.watch(taskRepositoryProvider));
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  return DeleteTaskUseCase(ref.watch(taskRepositoryProvider));
});

final getTaskByIdUseCaseProvider = Provider<GetTaskByIdUseCase>((ref) {
  return GetTaskByIdUseCase(ref.watch(taskRepositoryProvider));
});

final getTasksForGoalUseCaseProvider = Provider<GetTasksForGoalUseCase>((ref) {
  return GetTasksForGoalUseCase(ref.watch(taskRepositoryProvider));
});
