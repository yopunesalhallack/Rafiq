// import 'package:rafiq_app/features/tasks/domain/entities/task_entity.dart';
// import 'package:rafiq_app/features/tasks/domain/repositories/task_repository.dart';

// //all tasks
// class GetTasksUseCase {
//   final TaskRepository repository;

//   GetTasksUseCase(this.repository);

//   Future<List<TaskEntity>> call({TaskFilter filter = TaskFilter.all}) {
//     return repository.getTasks(filter: filter);
//   }
// }

// //Today tasks
// class GetTodayTasksUseCase {
//   final TaskRepository repository;

//   GetTodayTasksUseCase(this.repository);

//   Future<List<TaskEntity>> call() {
//     return repository.getTodayTasks();
//   }
// }

// //Task for ID
// class GetTaskByIdUseCase {
//   final TaskRepository repository;

//   GetTaskByIdUseCase(this.repository);

//   Future<TaskEntity?> call(int id) {
//     return repository.getTaskById(id);
//   }
// }

// // task for Goal
// class GetTasksForGoalUseCase {
//   final TaskRepository repository;

//   GetTasksForGoalUseCase(this.repository);

//   Future<List<TaskEntity>> call(int goalId) {
//     return repository.getTasksForGoal(goalId);
//   }
// }
