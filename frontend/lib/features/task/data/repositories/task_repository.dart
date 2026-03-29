import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskRepository {
  static const String _boxName = 'tasks';
  Box<TaskModel>? _box;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (_isInitialized) return;
    _box = await Hive.openBox<TaskModel>(_boxName);
    _isInitialized = true;
  }

  List<TaskModel> getAllTasks() {
    if (_box == null) return [];
    return _box!.values.toList();
  }

  List<TaskModel> getTasks({bool? completed}) {
    final tasks = getAllTasks();
    if (completed != null) {
      return tasks.where((t) => t.completed == completed).toList();
    }
    return tasks;
  }

  TaskModel? getTaskById(String id) {
    if (_box == null) return null;
    try {
      return _box!.values.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> addTask(TaskModel task) async {
    if (_box == null) return;
    await _box!.put(task.id, task);
  }

  Future<void> updateTask(TaskModel task) async {
    if (_box == null) return;
    await _box!.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    if (_box == null) return;
    await _box!.delete(id);
  }

  Future<void> toggleComplete(String id) async {
    if (_box == null) return;
    final task = getTaskById(id);
    if (task != null) {
      task.completed = !task.completed;
      task.updatedAt = DateTime.now();
      await task.save();
    }
  }

  List<String> getAllCategories() {
    if (_box == null) return [];
    final categories = _box!.values
        .map((t) => t.category)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();
    return categories;
  }

  Future<void> addCategory(String category) async {}
}
