import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/task_providers.dart';
import '../../data/models/task_model.dart';

class TaskCreatePage extends ConsumerStatefulWidget {
  final String? taskId;

  const TaskCreatePage({super.key, this.taskId});

  @override
  ConsumerState<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends ConsumerState<TaskCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _durationController = TextEditingController();

  DateTime? _deadline;
  TaskPriority _priority = TaskPriority.medium;
  RepeatType _repeat = RepeatType.none;
  bool _isEditing = false;
  TaskModel? _existingTask;

  @override
  void initState() {
    super.initState();
    if (widget.taskId != null) {
      _isEditing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadTask();
      });
    }
  }

  void _loadTask() {
    final tasks = ref.read(tasksProvider);
    try {
      _existingTask = tasks.firstWhere((t) => t.id == widget.taskId);
      _titleController.text = _existingTask!.title;
      _descController.text = _existingTask!.description ?? '';
      _categoryController.text = _existingTask!.category ?? '';
      _durationController.text =
          _existingTask!.estimatedDuration?.toString() ?? '';
      setState(() {
        _deadline = _existingTask!.deadline;
        _priority = _existingTask!.priority;
        _repeat = _existingTask!.repeat;
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.read(tasksProvider.notifier).categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑任务' : '新建任务'),
        actions: [TextButton(onPressed: _saveTask, child: const Text('保存'))],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: '任务标题 *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入任务标题';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: '描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('截止时间'),
              subtitle: Text(
                _deadline != null
                    ? DateFormat('yyyy-MM-dd HH:mm').format(_deadline!)
                    : '未设置',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_deadline != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _deadline = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDeadline,
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('优先级'),
              trailing: SegmentedButton<TaskPriority>(
                segments: const [
                  ButtonSegment(value: TaskPriority.low, label: Text('低')),
                  ButtonSegment(value: TaskPriority.medium, label: Text('中')),
                  ButtonSegment(value: TaskPriority.high, label: Text('高')),
                ],
                selected: {_priority},
                onSelectionChanged: (value) {
                  setState(() => _priority = value.first);
                },
              ),
            ),
            const Divider(),
            Autocomplete<String>(
              initialValue: TextEditingValue(text: _categoryController.text),
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return categories;
                }
                return categories.where(
                  (c) => c.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  ),
                );
              },
              onSelected: (value) {
                _categoryController.text = value;
              },
              fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                _categoryController.text = controller.text;
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: '分类',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.label_outline),
                  ),
                  onChanged: (value) => _categoryController.text = value,
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: '预计时长（分钟）',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.timer_outlined),
              ),
              keyboardType: TextInputType.number,
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('重复'),
              trailing: DropdownButton<RepeatType>(
                value: _repeat,
                onChanged: (value) {
                  if (value != null) setState(() => _repeat = value);
                },
                items: const [
                  DropdownMenuItem(value: RepeatType.none, child: Text('不重复')),
                  DropdownMenuItem(value: RepeatType.daily, child: Text('每天')),
                  DropdownMenuItem(value: RepeatType.weekly, child: Text('每周')),
                  DropdownMenuItem(
                    value: RepeatType.custom,
                    child: Text('自定义'),
                  ),
                ],
              ),
            ),
            if (_isEditing) ...[
              const Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('删除任务', style: TextStyle(color: Colors.red)),
                trailing: const Icon(Icons.delete_outline, color: Colors.red),
                onTap: _deleteTask,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: _deadline != null
            ? TimeOfDay.fromDateTime(_deadline!)
            : TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _deadline = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    if (!_formKey.currentState!.validate()) return;

    final duration = int.tryParse(_durationController.text);

    if (_isEditing && _existingTask != null) {
      final updated = _existingTask!.copyWith(
        title: _titleController.text.trim(),
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        deadline: _deadline,
        priorityIndex: _priority.index,
        category: _categoryController.text.trim().isEmpty
            ? null
            : _categoryController.text.trim(),
        estimatedDuration: duration,
        repeatIndex: _repeat.index,
      );
      ref.read(tasksProvider.notifier).updateTask(updated);
    } else {
      ref
          .read(tasksProvider.notifier)
          .addTask(
            title: _titleController.text.trim(),
            description: _descController.text.trim().isEmpty
                ? null
                : _descController.text.trim(),
            deadline: _deadline,
            priority: _priority,
            category: _categoryController.text.trim().isEmpty
                ? null
                : _categoryController.text.trim(),
            estimatedDuration: duration,
            repeat: _repeat,
          );
    }
    context.pop();
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这个任务吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              ref.read(tasksProvider.notifier).deleteTask(widget.taskId!);
              Navigator.pop(context);
              context.go('/tasks');
            },
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
