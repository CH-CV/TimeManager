import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/pomodoro_record.dart';
import '../providers/pomodoro_providers.dart';

class PomodoroHistoryPage extends ConsumerWidget {
  const PomodoroHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(pomodoroHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('番茄钟历史')),
      body: records.isEmpty
          ? const Center(child: Text('暂无记录'))
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[records.length - 1 - index];
                return _PomodoroRecordCard(record: record);
              },
            ),
    );
  }
}

class _PomodoroRecordCard extends StatelessWidget {
  final PomodoroRecord record;

  const _PomodoroRecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd HH:mm');
    final typeLabel = _getTypeLabel(record.type);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getTypeColor(record.type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getTypeIcon(record.type),
                color: _getTypeColor(record.type),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    typeLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(record.startTime),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (record.durationMinutes > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${record.durationMinutes}分钟',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
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

  IconData _getTypeIcon(PomodoroType type) {
    switch (type) {
      case PomodoroType.work:
        return Icons.work;
      case PomodoroType.shortBreak:
        return Icons.coffee;
      case PomodoroType.longBreak:
        return Icons.self_improvement;
    }
  }
}
