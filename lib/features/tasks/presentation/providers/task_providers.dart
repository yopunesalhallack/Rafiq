import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:rafiq_app/features/tasks/domain/entities/task_entity.dart';
import 'package:rafiq_app/features/tasks/domain/repositories/task_repository.dart';
import 'package:rafiq_app/features/tasks/domain/usecases/add_task_usecase.dart';
import 'package:rafiq_app/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:rafiq_app/features/tasks/domain/usecases/update_task_status_usecase.dart';
import '../../../../core/database/isar_service.dart';
import '../../data/repositories/task_repository_impl.dart';
//import '../../domain/usecases/get_today_tasks.dart'; // سننشئه

final isarServiceProvider = FutureProvider<Isar>((ref) {
  final service = IsarService();
  return service.db;
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  // نستخدم .requireValue لتأكيد أن Isar جاهز
  final isar = ref.watch(isarServiceProvider).requireValue;
  return TaskRepositoryImpl(isar);
});

final getTodayTasksProvider = FutureProvider<List<TaskEntity>>((ref) async {
  final repo = ref.watch(taskRepositoryProvider);
  return await repo.getTodayTasks();
});
final addTaskUseCaseProvider = Provider<AddTaskUseCase>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return AddTaskUseCase(repo);
});

final deleteTaskUseCaseProvider = Provider<DeleteTaskUseCase>((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return DeleteTaskUseCase(repo);
});

final updateTaskStatusUseCaseProvider = Provider<UpdateTaskStatusUseCase>((
  ref,
) {
  final repo = ref.watch(taskRepositoryProvider);
  return UpdateTaskStatusUseCase(repo);
});
