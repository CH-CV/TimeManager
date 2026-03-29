import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../services/notification_service.dart';
import '../../data/models/pomodoro_record.dart';

class PomodoroState {
  final int remainingSeconds;
  final bool isRunning;
  final PomodoroType currentType;
  final int completedPomodoros;
  final PomodoroRecord? currentRecord;

  const PomodoroState({
    this.remainingSeconds = 25 * 60,
    this.isRunning = false,
    this.currentType = PomodoroType.work,
    this.completedPomodoros = 0,
    this.currentRecord,
  });

  PomodoroState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    PomodoroType? currentType,
    int? completedPomodoros,
    PomodoroRecord? currentRecord,
  }) {
    return PomodoroState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      currentType: currentType ?? this.currentType,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      currentRecord: currentRecord ?? this.currentRecord,
    );
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  Timer? _timer;
  final Uuid _uuid = const Uuid();

  static const int workDuration = 25 * 60;
  static const int shortBreakDuration = 5 * 60;
  static const int longBreakDuration = 15 * 60;

  PomodoroNotifier() : super(const PomodoroState());

  void start(String? taskId) {
    if (state.isRunning) return;

    final record = PomodoroRecord(
      id: _uuid.v4(),
      startTime: DateTime.now(),
      typeIndex: state.currentType.index,
      taskId: taskId,
    );

    state = state.copyWith(isRunning: true, currentRecord: record);

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _onTimerComplete();
      }
    });
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = PomodoroState(completedPomodoros: state.completedPomodoros);
  }

  void skip() {
    _timer?.cancel();
    _moveToNext();
  }

  Future<void> _onTimerComplete() async {
    _timer?.cancel();

    if (state.currentType == PomodoroType.work && state.currentRecord != null) {
      final box = await Hive.openBox<PomodoroRecord>('pomodoro_records');
      final completedRecord = PomodoroRecord(
        id: state.currentRecord!.id,
        startTime: state.currentRecord!.startTime,
        endTime: DateTime.now(),
        typeIndex: state.currentRecord!.typeIndex,
        taskId: state.currentRecord!.taskId,
      );
      await box.put(completedRecord.id, completedRecord);

      await NotificationService().showPomodoroNotification(
        title: '🍅 番茄完成',
        body: '恭喜完成一个番茄钟！',
      );
    } else {
      final typeLabel = state.currentType == PomodoroType.shortBreak
          ? '短'
          : '长';
      await NotificationService().showPomodoroNotification(
        title: '☕ $typeLabel休息结束',
        body: '休息结束，开始下一个番茄钟吧！',
      );
    }

    if (state.currentType == PomodoroType.work) {
      state = state.copyWith(completedPomodoros: state.completedPomodoros + 1);
    }

    _moveToNext();
  }

  void _moveToNext() {
    PomodoroType nextType;
    int nextDuration;

    if (state.currentType == PomodoroType.work) {
      if ((state.completedPomodoros) % 4 == 0) {
        nextType = PomodoroType.longBreak;
        nextDuration = longBreakDuration;
      } else {
        nextType = PomodoroType.shortBreak;
        nextDuration = shortBreakDuration;
      }
    } else {
      nextType = PomodoroType.work;
      nextDuration = workDuration;
    }

    state = state.copyWith(
      remainingSeconds: nextDuration,
      currentType: nextType,
      isRunning: false,
      currentRecord: null,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final pomodoroProvider = StateNotifierProvider<PomodoroNotifier, PomodoroState>(
  (ref) {
    return PomodoroNotifier();
  },
);

final pomodoroHistoryProvider =
    StateNotifierProvider<PomodoroHistoryNotifier, List<PomodoroRecord>>((ref) {
      return PomodoroHistoryNotifier();
    });

class PomodoroHistoryNotifier extends StateNotifier<List<PomodoroRecord>> {
  PomodoroHistoryNotifier() : super([]) {
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final box = await Hive.openBox<PomodoroRecord>('pomodoro_records');
    state = box.values.toList();
  }

  Future<void> addRecord(PomodoroRecord record) async {
    final box = await Hive.openBox<PomodoroRecord>('pomodoro_records');
    await box.put(record.id, record);
    state = [...state, record];
  }
}
