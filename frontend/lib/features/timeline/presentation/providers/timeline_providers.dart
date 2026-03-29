import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../task/presentation/providers/task_providers.dart';

class TimelineBlock {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String type;
  final String? taskId;

  const TimelineBlock({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.type,
    this.taskId,
  });
}

class TimelineState {
  final DateTime selectedDate;
  final List<TimelineBlock> blocks;

  const TimelineState({required this.selectedDate, this.blocks = const []});

  TimelineState copyWith({
    DateTime? selectedDate,
    List<TimelineBlock>? blocks,
  }) {
    return TimelineState(
      selectedDate: selectedDate ?? this.selectedDate,
      blocks: blocks ?? this.blocks,
    );
  }
}

class TimelineNotifier extends StateNotifier<TimelineState> {
  TimelineNotifier() : super(TimelineState(selectedDate: DateTime.now())) {
    _loadBlocks();
  }

  void _loadBlocks() {
    // Blocks are loaded reactively based on selected date
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void goToPreviousDay() {
    state = state.copyWith(
      selectedDate: state.selectedDate.subtract(const Duration(days: 1)),
    );
  }

  void goToNextDay() {
    state = state.copyWith(
      selectedDate: state.selectedDate.add(const Duration(days: 1)),
    );
  }

  void goToToday() {
    state = state.copyWith(selectedDate: DateTime.now());
  }
}

final timelineProvider = StateNotifierProvider<TimelineNotifier, TimelineState>(
  (ref) {
    return TimelineNotifier();
  },
);

final timelineBlocksProvider = Provider<List<TimelineBlock>>((ref) {
  final timelineState = ref.watch(timelineProvider);
  final tasks = ref.watch(tasksProvider);
  final selectedDate = timelineState.selectedDate;

  final blocks = <TimelineBlock>[];

  for (final task in tasks) {
    if (task.deadline != null && _isSameDay(task.deadline!, selectedDate)) {
      blocks.add(
        TimelineBlock(
          id: 'task_${task.id}',
          title: task.title,
          startTime: task.deadline!,
          endTime: task.deadline!.add(
            Duration(minutes: task.estimatedDuration ?? 30),
          ),
          type: 'task',
          taskId: task.id,
        ),
      );
    }
  }

  blocks.sort((a, b) => a.startTime.compareTo(b.startTime));

  return blocks;
});

bool _isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

final formattedSelectedDateProvider = Provider<String>((ref) {
  final selectedDate = ref.watch(
    timelineProvider.select((s) => s.selectedDate),
  );
  final now = DateTime.now();

  if (_isSameDay(selectedDate, now)) {
    return '今天';
  } else if (_isSameDay(selectedDate, now.subtract(const Duration(days: 1)))) {
    return '昨天';
  } else if (_isSameDay(selectedDate, now.add(const Duration(days: 1)))) {
    return '明天';
  } else {
    return DateFormat('MM/dd').format(selectedDate);
  }
});
