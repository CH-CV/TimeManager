import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/pomodoro_providers.dart';
import '../../data/models/pomodoro_record.dart';

class PomodoroPage extends ConsumerWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoro = ref.watch(pomodoroProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('番茄钟'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/pomodoro/history'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(pomodoroProvider.notifier).reset(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getTypeLabel(pomodoro.currentType),
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value:
                        1 -
                        (pomodoro.remainingSeconds /
                            _getTotalSeconds(pomodoro.currentType)),
                    strokeWidth: 12,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getTypeColor(pomodoro.currentType),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      pomodoro.formattedTime,
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    Text(
                      '第 ${pomodoro.completedPomodoros + 1} 个番茄',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!pomodoro.isRunning)
                  FilledButton.icon(
                    onPressed: () =>
                        ref.read(pomodoroProvider.notifier).start(null),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('开始'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: () =>
                        ref.read(pomodoroProvider.notifier).pause(),
                    icon: const Icon(Icons.pause),
                    label: const Text('暂停'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => ref.read(pomodoroProvider.notifier).skip(),
                  child: const Text('跳过'),
                ),
              ],
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final isCompleted = index < pomodoro.completedPomodoros % 4;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              '4 个番茄后长休息',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeLabel(PomodoroType type) {
    switch (type) {
      case PomodoroType.work:
        return '专注工作';
      case PomodoroType.shortBreak:
        return '短休息';
      case PomodoroType.longBreak:
        return '长休息';
    }
  }

  Color _getTypeColor(PomodoroType type) {
    switch (type) {
      case PomodoroType.work:
        return Colors.red;
      case PomodoroType.shortBreak:
        return Colors.green;
      case PomodoroType.longBreak:
        return Colors.blue;
    }
  }

  int _getTotalSeconds(PomodoroType type) {
    switch (type) {
      case PomodoroType.work:
        return 25 * 60;
      case PomodoroType.shortBreak:
        return 5 * 60;
      case PomodoroType.longBreak:
        return 15 * 60;
    }
  }
}
