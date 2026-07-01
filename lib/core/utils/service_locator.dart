// import 'package:get_it/get_it.dart';
// import 'package:rafiq_app/core/database/isar_service.dart'; // تأكد من المسار
// import 'package:rafiq_app/features/goals/data/repositories/goal_repository_impl.dart';
// import 'package:rafiq_app/features/goals/domain/repositories/goal_repository.dart';
// import 'package:rafiq_app/features/tasks/data/repositories/task_repository_impl.dart';
// import 'package:rafiq_app/features/tasks/domain/repositories/task_repository.dart';

// final getIt = GetIt.instance;

// Future<void> setupServiceLocator() async {
//   final isarService = IsarService();
//   await isarService.db;
//   getIt.registerSingleton<IsarService>(isarService);

//   getIt.registerSingleton<GoalRepository>(
//     GoalRepositoryImpl(getIt<IsarService>()),
//   );

//   getIt.registerSingleton<TaskRepository>(
//     TaskRepositoryImpl(getIt<IsarService>()),
//   );
// }
