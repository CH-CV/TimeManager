import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/task/presentation/pages/task_list_page.dart';
import '../features/task/presentation/pages/task_detail_page.dart';
import '../features/task/presentation/pages/task_create_page.dart';
import '../features/pomodoro/presentation/pages/pomodoro_page.dart';
import '../features/pomodoro/presentation/pages/pomodoro_history_page.dart';
import '../features/timeline/presentation/pages/timeline_page.dart';
import '../features/statistics/presentation/pages/statistics_page.dart';
import '../features/ai/presentation/pages/ai_assistant_page.dart';
import '../features/auth/presentation/pages/settings_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/tasks',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/tasks',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TaskListPage()),
          ),
          GoRoute(
            path: '/timeline',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TimelinePage()),
          ),
          GoRoute(
            path: '/pomodoro',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: PomodoroPage()),
            routes: [
              GoRoute(
                path: 'history',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const PomodoroHistoryPage(),
              ),
            ],
          ),
          GoRoute(
            path: '/statistics',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StatisticsPage()),
          ),
          GoRoute(
            path: '/ai',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AIAssistantPage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
      GoRoute(
        path: '/tasks/new',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TaskCreatePage(),
      ),
      GoRoute(
        path: '/tasks/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            TaskDetailPage(taskId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tasks/:id/edit',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) =>
            TaskCreatePage(taskId: state.pathParameters['id']),
      ),
    ],
  );
});

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: '任务',
          ),
          NavigationDestination(
            icon: Icon(Icons.timeline_outlined),
            selectedIcon: Icon(Icons.timeline),
            label: '时间轴',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: '番茄钟',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(Icons.smart_toy_outlined),
            selectedIcon: Icon(Icons.smart_toy),
            label: 'AI',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '设置',
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/tasks')) return 0;
    if (location.startsWith('/timeline')) return 1;
    if (location.startsWith('/pomodoro')) return 2;
    if (location.startsWith('/statistics')) return 3;
    if (location.startsWith('/ai')) return 4;
    if (location.startsWith('/settings')) return 5;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/tasks');
        break;
      case 1:
        context.go('/timeline');
        break;
      case 2:
        context.go('/pomodoro');
        break;
      case 3:
        context.go('/statistics');
        break;
      case 4:
        context.go('/ai');
        break;
      case 5:
        context.go('/settings');
        break;
    }
  }
}
