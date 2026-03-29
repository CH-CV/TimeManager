import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/timeline_providers.dart';

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(timelineProvider);
    final blocks = ref.watch(timelineBlocksProvider);
    final formattedDate = ref.watch(formattedSelectedDateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('时间轴')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () =>
                      ref.read(timelineProvider.notifier).goToPreviousDay(),
                ),
                GestureDetector(
                  onTap: () => ref.read(timelineProvider.notifier).goToToday(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () =>
                      ref.read(timelineProvider.notifier).goToNextDay(),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: blocks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_available,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '今天没有安排',
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 24,
                    itemBuilder: (context, hour) {
                      return TimelineHourRow(
                        hour: hour,
                        blocks: blocks.where((b) {
                          return b.startTime.hour == hour;
                        }).toList(),
                        onBlockTap: (block) {
                          if (block.taskId != null) {
                            context.push('/tasks/${block.taskId}');
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class TimelineHourRow extends StatelessWidget {
  final int hour;
  final List<TimelineBlock> blocks;
  final Function(TimelineBlock) onBlockTap;

  const TimelineHourRow({
    super.key,
    required this.hour,
    required this.blocks,
    required this.onBlockTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '${hour.toString().padLeft(2, '0')}:00',
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
                ...blocks.map(
                  (block) => Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => onBlockTap(block),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getBlockColor(block.type),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          block.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBlockColor(String type) {
    switch (type) {
      case 'task':
        return Colors.blue;
      case 'pomodoro':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
