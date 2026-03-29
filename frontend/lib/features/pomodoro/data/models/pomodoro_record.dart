import 'package:hive/hive.dart';

part 'pomodoro_record.g.dart';

enum PomodoroType { work, shortBreak, longBreak }

@HiveType(typeId: 1)
class PomodoroRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime startTime;

  @HiveField(2)
  DateTime? endTime;

  @HiveField(3)
  int typeIndex;

  @HiveField(4)
  String? taskId;

  @HiveField(5)
  bool completed;

  PomodoroRecord({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.typeIndex,
    this.taskId,
    this.completed = false,
  });

  PomodoroType get type => PomodoroType.values[typeIndex];
  set type(PomodoroType value) => typeIndex = value.index;

  int get durationMinutes {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inMinutes;
  }
}
