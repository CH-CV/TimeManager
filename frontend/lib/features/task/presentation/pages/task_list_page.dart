import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/task_providers.dart';
import '../../data/models/task_model.dart';

class TaskListPage extends ConsumerWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasksProvider);
    final filter = ref.watch(taskFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('任务'),
        actions: [
          PopupMenuButton<TaskFilter>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(taskFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: TaskFilter.all,
                child: Row(
                  children: [
                    if (filter == TaskFilter.all)
                      const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('全部'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskFilter.pending,
                child: Row(
                  children: [
                    if (filter == TaskFilter.pending)
                      const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('未完成'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: TaskFilter.completed,
                child: Row(
                  children: [
                    if (filter == TaskFilter.completed)
                      const Icon(Icons.check, size: 18),
                    const SizedBox(width: 8),
                    const Text('已完成'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无任务',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(task: task);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tasks/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskCard extends ConsumerWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priorityColor = _getPriorityColor(task.priority);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/tasks/${task.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              GestureDetector(
                onTap: () =>
                    ref.read(tasksProvider.notifier).toggleComplete(task.id),
                child: Container(
                  width: 24,
                  height: 24,
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
                          size: 16,
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: task.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.completed
                            ? Theme.of(context).colorScheme.outline
                            : null,
                      ),
                    ),
                    if (task.description != null &&
                        task.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: priorityColor,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getPriorityText(task.priority),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        if (task.category != null &&
                            task.category!.isNotEmpty) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.label_outline,
                            size: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.category!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                        if (task.deadline != null) ...[
                          const SizedBox(width: 12),
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('MM/dd HH:mm').format(task.deadline!),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
        ),
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
        return '高';
      case TaskPriority.medium:
        return '中';
      case TaskPriority.low:
        return '低';
    }
  }
}
