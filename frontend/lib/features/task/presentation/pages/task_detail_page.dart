import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/task_providers.dart';
import '../../data/models/task_model.dart';

class TaskDetailPage extends ConsumerWidget {
  final String taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
    TaskModel? task;
    try {
      task = tasks.firstWhere((t) => t.id == taskId);
    } catch (_) {
      return Scaffold(
        appBar: AppBar(title: const Text('任务详情')),
        body: const Center(child: Text('任务不存在')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('任务详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/tasks/${task!.id}/edit'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () =>
                    ref.read(tasksProvider.notifier).toggleComplete(task!.id),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: task.completed
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                    color: task.completed
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  child: task.completed
                      ? Icon(
                          Icons.check,
                          size: 20,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (task.description != null && task.description!.isNotEmpty) ...[
            Text(
              task.description!,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
          ],
          _DetailRow(
            icon: Icons.flag,
            label: '优先级',
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(task.priority).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getPriorityText(task.priority),
                style: TextStyle(
                  color: _getPriorityColor(task.priority),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (task.category != null && task.category!.isNotEmpty)
            _DetailRow(
              icon: Icons.label_outline,
              label: '分类',
              child: Text(task.category!),
            ),
          if (task.deadline != null)
            _DetailRow(
              icon: Icons.schedule,
              label: '截止时间',
              child: Text(
                DateFormat('yyyy-MM-dd HH:mm').format(task.deadline!),
                style: TextStyle(
                  color: task.deadline!.isBefore(DateTime.now())
                      ? Colors.red
                      : null,
                ),
              ),
            ),
          if (task.estimatedDuration != null)
            _DetailRow(
              icon: Icons.timer_outlined,
              label: '预计时长',
              child: Text('${task.estimatedDuration} 分钟'),
            ),
          _DetailRow(
            icon: Icons.repeat,
            label: '重复',
            child: Text(_getRepeatText(task.repeat)),
          ),
          const Divider(height: 32),
          _DetailRow(
            icon: Icons.access_time,
            label: '创建时间',
            child: Text(DateFormat('yyyy-MM-dd HH:mm').format(task.createdAt)),
          ),
          _DetailRow(
            icon: Icons.update,
            label: '更新时间',
            child: Text(DateFormat('yyyy-MM-dd HH:mm').format(task.updatedAt)),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  String _getPriorityText(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return '高优先级';
      case TaskPriority.medium:
        return '中优先级';
      case TaskPriority.low:
        return '低优先级';
    }
  }

  String _getRepeatText(RepeatType repeat) {
    switch (repeat) {
      case RepeatType.none:
        return '不重复';
      case RepeatType.daily:
        return '每天';
      case RepeatType.weekly:
        return '每周';
      case RepeatType.custom:
        return '自定义';
    }
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget child;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
