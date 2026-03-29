import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/task_model.dart';
import '../../data/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final repo = TaskRepository();
  ref.onDispose(() {});
  return repo;
});

final tasksProvider = StateNotifierProvider<TasksNotifier, List<TaskModel>>((
  ref,
) {
  final repository = ref.watch(taskRepositoryProvider);
  return TasksNotifier(repository);
});

class TasksNotifier extends StateNotifier<List<TaskModel>> {
  final TaskRepository _repository;
  final _uuid = const Uuid();

  TasksNotifier(this._repository) : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    await _repository.init();
    state = _repository.getAllTasks();
  }

  Future<void> addTask({
    required String title,
    String? description,
    DateTime? deadline,
    TaskPriority priority = TaskPriority.medium,
    String? category,
    int? estimatedDuration,
    RepeatType repeat = RepeatType.none,
  }) async {
    final now = DateTime.now();
    final task = TaskModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      deadline: deadline,
      priorityIndex: priority.index,
      category: category,
      estimatedDuration: estimatedDuration,
      repeatIndex: repeat.index,
      completed: false,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.addTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(TaskModel task) async {
    final updatedTask = task.copyWith(updatedAt: DateTime.now());
    await _repository.updateTask(updatedTask);
    state = [
      for (final t in state)
        if (t.id == task.id) updatedTask else t,
    ];
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    state = state.where((t) => t.id != id).toList();
  }

  Future<void> toggleComplete(String id) async {
    await _repository.toggleComplete(id);
    state = [
      for (final t in state)
        if (t.id == id)
          t.copyWith(completed: !t.completed, updatedAt: DateTime.now())
        else
          t,
    ];
  }

  List<String> get categories => _repository.getAllCategories();
}

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);

enum TaskFilter { all, pending, completed }

final filteredTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(tasksProvider);
  final filter = ref.watch(taskFilterProvider);

  switch (filter) {
    case TaskFilter.all:
      return tasks;
    case TaskFilter.pending:
      return tasks.where((t) => !t.completed).toList();
    case TaskFilter.completed:
      return tasks.where((t) => t.completed).toList();
  }
});
