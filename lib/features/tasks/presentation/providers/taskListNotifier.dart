// import 'package:flutter_riverpod/legacy.dart';
// import 'package:rafiq_app/features/tasks/domain/repositories/task_repository.dart';
// import 'package:rafiq_app/features/tasks/domain/usecases/update_task_status_usecase.dart';
// import '../../domain/entities/task_entity.dart';
// import '../../domain/usecases/get_tasks_usecase.dart';
// import '../../domain/usecases/add_task_usecase.dart';
// import '../../domain/usecases/delete_task_usecase.dart';
// import 'task_providers.dart';

// /// TaskListState
// class TaskListState {
//   final List<TaskEntity> tasks;
//   final bool loading;
//   final String? error;
//   final TaskFilter filter;

//   const TaskListState({
//     required this.tasks,
//     required this.loading,
//     required this.filter,
//     this.error,
//   });

//   factory TaskListState.initial() =>
//       const TaskListState(tasks: [], loading: false, filter: TaskFilter.all);

//   TaskListState copyWith({
//     List<TaskEntity>? tasks,
//     bool? loading,
//     String? error,
//     TaskFilter? filter,
//   }) {
//     return TaskListState(
//       tasks: tasks ?? this.tasks,
//       loading: loading ?? this.loading,
//       filter: filter ?? this.filter,
//       error: error,
//     );
//   }
// }

// /// 2) TaskListNotifier
// class TaskListNotifier extends StateNotifier<TaskListState> {
//   final GetTasksUseCase getTasks;
//   final GetTodayTasksUseCase getTodayTasks;
//   final AddTaskUseCase addTask;
//   final UpdateTaskUseCase updateTask;
//   final DeleteTaskUseCase deleteTask;
//   final GetTaskByIdUseCase getTaskById;
//   final GetTasksForGoalUseCase getTasksForGoal;

//   TaskListNotifier({
//     required this.getTasks,
//     required this.getTodayTasks,
//     required this.addTask,
//     required this.updateTask,
//     required this.deleteTask,
//     required this.getTaskById,
//     required this.getTasksForGoal,
//   }) : super(TaskListState.initial()) {
//     loadTasks();
//   }

//   /// load tasks based on a selected filter
//   Future<void> loadTasks({TaskFilter? filter}) async {
//     final selectedFilter = filter ?? state.filter;

//     state = state.copyWith(loading: true, filter: selectedFilter);

//     try {
//       List<TaskEntity> tasks;

//       switch (selectedFilter) {
//         case TaskFilter.today:
//           tasks = await getTodayTasks();
//           break;

//         case TaskFilter.upcoming:
//           tasks = await getTasks(filter: TaskFilter.upcoming);
//           break;

//         case TaskFilter.all:
//           tasks = await getTasks(filter: TaskFilter.all);
//           break;
//       }

//       state = state.copyWith(tasks: tasks, loading: false);
//     } catch (e) {
//       state = state.copyWith(error: e.toString(), loading: false);
//     }
//   }

//   ///  Add a new task
//   Future<void> addNewTask(TaskEntity task) async {
//     await addTask(task);
//     await loadTasks();
//   }

//   ///  Update task
//   Future<void> updateExistingTask(TaskEntity task) async {
//     await updateTask(task);
//     await loadTasks();
//   }

//   ///  delet task
//   Future<void> removeTask(int id) async {
//     await deleteTask(id);
//     await loadTasks();
//   }

//   ///  load one task
//   Future<TaskEntity?> loadTaskById(int id) async {
//     return await getTaskById(id);
//   }

//   /// load a goal using goalid
//   Future<void> loadTasksForGoal(int goalId) async {
//     state = state.copyWith(loading: true);

//     try {
//       final tasks = await getTasksForGoal(goalId);
//       state = state.copyWith(tasks: tasks, loading: false);
//     } catch (e) {
//       state = state.copyWith(error: e.toString(), loading: false);
//     }
//   }
// }

// /// ------------------------------
// /// 3) Provider
// /// ------------------------------
// final taskListNotifierProvider =
//     StateNotifierProvider<TaskListNotifier, TaskListState>((ref) {
//       return TaskListNotifier(
//         getTasks: ref.watch(getTasksUseCaseProvider),
//         getTodayTasks: ref.watch(getTodayTasksUseCaseProvider),
//         addTask: ref.watch(addTaskUseCaseProvider),
//         updateTask: ref.watch(updateTaskUseCaseProvider),
//         deleteTask: ref.watch(deleteTaskUseCaseProvider),
//         getTaskById: ref.watch(getTaskByIdUseCaseProvider),
//         getTasksForGoal: ref.watch(getTasksForGoalUseCaseProvider),
//       );
//     });
