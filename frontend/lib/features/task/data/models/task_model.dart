import 'package:hive/hive.dart';

part 'task_model.g.dart';

enum TaskPriority { low, medium, high }

enum RepeatType { none, daily, weekly, custom }

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  DateTime? deadline;

  @HiveField(4)
  int priorityIndex;

  @HiveField(5)
  String? category;

  @HiveField(6)
  int? estimatedDuration;

  @HiveField(7)
  int repeatIndex;

  @HiveField(8)
  bool completed;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    this.priorityIndex = 1,
    this.category,
    this.estimatedDuration,
    this.repeatIndex = 0,
    this.completed = false,
    required this.createdAt,
    required this.updatedAt,
  });

  TaskPriority get priority => TaskPriority.values[priorityIndex];
  set priority(TaskPriority value) => priorityIndex = value.index;

  RepeatType get repeat => RepeatType.values[repeatIndex];
  set repeat(RepeatType value) => repeatIndex = value.index;

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    int? priorityIndex,
    String? category,
    int? estimatedDuration,
    int? repeatIndex,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priorityIndex: priorityIndex ?? this.priorityIndex,
      category: category ?? this.category,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      repeatIndex: repeatIndex ?? this.repeatIndex,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
